#include <cstdlib>
#include <cstdio>
#include <iostream>

#include <re2/re2.h>
#include <re2/filtered_re2.h>

#include "k.h"

using namespace re2;
using namespace std;

Z S makeKErrMsg(S s1, S s2)
{
    Z __thread char b[256];
    snprintf(b, 256, "%s - %s", s1, s2);
    R b;
}

Z __inline S CopyQChars(S s, J n)
{
    S r = (S)malloc(n + 1);
    R r ? memcpy(r, s, n), r[n] = 0, r : (S)krr((S) "re2-wsfull");
}

static bool isStringLikeType(K k)
{
    signed char t = k->t;
    if (t)
    {
        return t == KC || t == KS || t == -KS;
    }
    else
    {
        for (J i = 0; i < k->n; i++)
        {
            if (kK(k)[i]->t != KC)
            {
                return false;
            }
        }
        return true;
    }
}

static K replaceByMethod(K regexp, K texts, K repl, bool (*func)(std::string *str, const RE2 &re, const StringPiece &rewrite))
{
    if ((regexp->t != KC && repl->t != KC) || !isStringLikeType(texts))
    {
        return krr((S) "re2-type");
    }
    S regexp_copy = CopyQChars((S)kC(regexp), regexp->n);
    S repl_copy = CopyQChars((S)kC(repl), repl->n);
    RE2 pattern(regexp_copy, RE2::Quiet);
    free(regexp_copy);
    if (!pattern.ok())
    {
        return krr(makeKErrMsg((S) "re2-bad regex", (S)pattern.error().c_str()));
    }
    if (texts->t == -KS || texts->t == KC)
    {
        S chars = texts->t == -KS ? texts->s : CopyQChars((S)kC(texts), texts->n);
        string str = chars;
        func(&str, pattern, repl_copy);
        free(repl_copy);
        return texts->t == -KS ? ks((char *)str.c_str()) : kpn((char *)str.c_str(), str.length());
    }
    else if (texts->t == KS)
    {
        K newText = ktn(KS, texts->n);
        for (J i = 0; i < texts->n; i++)
        {
            S sym = kS(texts)[i];
            string text = sym;
            S chars = CopyQChars(sym, text.length());
            text = chars;
            P(!chars, (r0(newText), (K)0))
            func(&text, pattern, repl_copy);
            kS(newText)[i] = ss((char *)text.c_str());
        }
        free(repl_copy);
        return newText;
    }
    else
    {
        K newText = ktn(0, texts->n);
        for (J i = 0; i < texts->n; i++)
        {
            K atom = kK(texts)[i];
            S chars = CopyQChars((S)kC(atom), atom->n);
            string text = chars;
            P(!chars, (r0(newText), (K)0))
            func(&text, pattern, repl_copy);
            kK(newText)[i] = kpn((char *)text.c_str(), text.length());
        }
        free(repl_copy);
        return newText;
    }
}

extern "C" K Replace(K regexp, K text, K repl)
{
    return replaceByMethod(regexp, text, repl, RE2::Replace);
}

extern "C" K ReplaceAll(K regexp, K text, K repl)
{
    return replaceByMethod(regexp, text, repl, [](std::string *str, const RE2 &re, const StringPiece &rewrite)
                           { return 0 < RE2::GlobalReplace(str, re, rewrite); });
}

template <typename... A>
static K matchByMethod(K regexp, K texts, bool (*func)(const StringPiece &, const RE2 &, A &&...a))
{
    S text;
    if (regexp->t != KC || !isStringLikeType(texts))
    {
        return krr((S) "re2-type");
    }
    S regexp_copy = CopyQChars((S)kC(regexp), regexp->n);
    RE2 pattern(regexp_copy, RE2::Quiet);
    free(regexp_copy);
    if (!pattern.ok())
    {
        return krr(makeKErrMsg((S) "re2-bad regex", (S)pattern.error().c_str()));
    }

    if (texts->t == -KS || texts->t == KC)
    {
        text = texts->t == -KS ? texts->s : CopyQChars((S)kC(texts), texts->n);
        K match = kb(func(text, pattern));
        if (text != texts->s)
            free(text);
        return match;
    }
    else if (texts->t == KS)
    {
        K matches = ktn(KB, texts->n);
        for (J i = 0; i < texts->n; i++)
        {
            kG(matches)[i] = func(kS(texts)[i], pattern);
        }
        return matches;
    }
    else
    {
        K matches = ktn(KB, texts->n);
        for (J i = 0; i < texts->n; i++)
        {
            K k_atom = kK(texts)[i];
            text = CopyQChars((S)kC(k_atom), k_atom->n);
            kG(matches)[i] = func(text, pattern);
            if (k_atom)
                free(text);
        }
        return matches;
    }
}

extern "C" K IsPartialMatch(K regexp, K text)
{
    return matchByMethod(regexp, text, RE2::PartialMatch);
}

extern "C" K IsFullMatch(K regexp, K text)
{
    return matchByMethod(regexp, text, RE2::FullMatch);
}

static void MatchN(
    const StringPiece &text,
    const RE2 &re,
    std::size_t group_num,
    std::vector<StringPiece> &match_groups)
{
    std::vector<RE2::Arg> args(group_num);
    std::vector<RE2::Arg *> arg_ptrs(group_num);
    for (std::size_t i = 0; i < group_num; ++i)
    {
        args[i] = &match_groups[i];
        arg_ptrs[i] = &args[i];
    }
    RE2::PartialMatchN(text, re, &(arg_ptrs[0]), group_num);
}

extern "C" K MatchGroups(K regexp, K texts)
{
    if (regexp->t != KC || !isStringLikeType(texts))
    {
        return krr((S) "re2-type");
    }
    S regexp_copy = CopyQChars((S)kC(regexp), regexp->n);
    RE2 pattern(regexp_copy, RE2::Quiet);
    free(regexp_copy);
    if (!pattern.ok())
    {
        return krr(makeKErrMsg((S) "re2-bad regex", (S)pattern.error().c_str()));
    }
    const std::map<std::string, int> &group_to_index = pattern.NamedCapturingGroups();
    std::size_t group_num = pattern.NumberOfCapturingGroups();
    if (group_num == 0)
    {
        return krr((S) "re2-no group found");
    }
    else if (group_num > 10)
    {
        return krr((S) "re2-too many groups(>10)");
    }

    K groups = ktn(KS, group_num);

    for (std::size_t i = 0; i < group_num; ++i)
    {
        char g[7];
        snprintf(g, 7, "group%d", (int)i);
        kS(groups)[i] = ss((char *)g);
    }

    std::map<std::string, int>::const_iterator iter_groups = group_to_index.cbegin();
    for (; iter_groups != group_to_index.cend(); ++iter_groups)
    {
        int index = iter_groups->second - 1;
        kS(groups)[index] = ss((char *)iter_groups->first.data());
    }

    if (texts->t == -KS)
    {
        StringPiece text_piece(texts->s);
        std::vector<StringPiece> matches(group_num);
        MatchN(text_piece, pattern, group_num, matches);
        K captures = ktn(KS, group_num);
        for (std::size_t i = 0; i < group_num; ++i)
        {
            S match = CopyQChars((char *)matches[i].data(), matches[i].length());
            kS(captures)[i] = ss(match);
        }
        return xD(groups, captures);
    }
    else if (texts->t == KC)
    {
        S text = CopyQChars((S)kC(texts), texts->n);
        StringPiece text_piece(text);
        std::vector<StringPiece> matches(group_num);
        MatchN(text_piece, pattern, group_num, matches);
        K captures = ktn(0, group_num);
        for (std::size_t i = 0; i < group_num; ++i)
        {
            kK(captures)[i] = kpn((char *)matches[i].data(), matches[i].length());
        }
        if (text != texts->s)
            free(text);
        return xD(groups, captures);
    }
    else if (texts->t == KS)
    {
        K captures = ktn(0, group_num);
        for (std::size_t i = 0; i < group_num; ++i)
        {
            kK(captures)[i] = ktn(KS, texts->n);
        }

        for (J i = 0; i < texts->n; i++)
        {
            S sym = kS(texts)[i];
            string text = sym;
            S chars = CopyQChars(sym, text.length());
            text = chars;
            P(!chars, (r0(captures), (K)0));

            StringPiece text_piece(text);
            std::vector<StringPiece> matches(group_num);
            MatchN(text_piece, pattern, group_num, matches);

            for (std::size_t j = 0; j < group_num; ++j)
            {
                S match = CopyQChars((char *)matches[j].data(), matches[j].length());
                kS(kK(captures)[j])[i] = ss(match);
            }

            free(chars);
        }
        return xD(groups, captures);
    }
    else
    {
        K captures = ktn(0, group_num);

        for (std::size_t i = 0; i < group_num; ++i)
        {
            kK(captures)[i] = ktn(0, texts->n);
        }

        for (J i = 0; i < texts->n; i++)
        {

            K atom = kK(texts)[i];
            S chars = CopyQChars((S)kC(atom), atom->n);
            string text = chars;
            P(!chars, (r0(captures), (K)0))

            StringPiece text_piece(text);
            std::vector<StringPiece> matches(group_num);
            MatchN(text_piece, pattern, group_num, matches);

            for (std::size_t j = 0; j < group_num; ++j)
            {
                kK(kK(captures)[j])[i] = kpn((char *)matches[j].data(), matches[j].length());
            }
            free(chars);
        }
        return xD(groups, captures);
    }
}

extern "C" K libre2(K x)
{
    K func = ktn(0, 5);
    x = ktn(KS, 5);
    xS[0] = ss((char *)"isPartialMatch");
    xS[1] = ss((char *)"isFullMatch");
    xS[2] = ss((char *)"replace");
    xS[3] = ss((char *)"replaceAll");
    xS[4] = ss((char *)"matchGroups");
    kK(func)[0] = dl(reinterpret_cast<V *>(IsPartialMatch), 2);
    kK(func)[1] = dl(reinterpret_cast<V *>(IsFullMatch), 2);
    kK(func)[2] = dl(reinterpret_cast<V *>(Replace), 3);
    kK(func)[3] = dl(reinterpret_cast<V *>(ReplaceAll), 3);
    kK(func)[4] = dl(reinterpret_cast<V *>(MatchGroups), 2);
    R xD(x, func);
}

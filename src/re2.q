.re2.path:` sv(first ` vs hsym `$first -3#value{}),`re2;
// load partialMatchN, partialMatch, fullMatch
.re2:(.re2.path 2:(`libre2;1))`;

.re2.MatchGroups:{[pattern;texts]
  .re2.validateArgs[`pattern`texts!(pattern;texts)];
  .re2.matchGroups[pattern;texts]
 };

.re2.Replace:{[pattern;texts;repl]
  .re2.validateArgs[`pattern`texts`repl!(pattern;texts;repl)];
  .re2.replace[pattern;texts;repl]
 };

.re2.ReplaceAll:{[pattern;texts;repl]
  .re2.validateArgs[`pattern`texts`repl!(pattern;texts;repl)];
  .re2.replaceAll[pattern;texts;repl]
 };

.re2.Match:{[pattern;texts]
  .re2.validateArgs[`pattern`texts!(pattern;texts)];
  .re2.partialMatch[pattern;texts]
  };

.re2.FullMatch:{[pattern;texts]
  .re2.validateArgs[`pattern`texts!(pattern;texts)];
  .re2.fullMatch[pattern;texts]
 };

.re2.validateArgs:{[args]
  if[`texts in key args;
    texts:args`texts;
    $[(0=count texts)&0h=type texts;
        "skip";
      not .Q.ty[args`texts]in "CcSs";
        '"requires string(s) or symbol(s) as texts";
        "skip"
    ];
  ];
  if[(`pattern in key args)&not 10h=type[args`pattern];'"requires string type as pattern"];
  if[(`repl in key args)&not 10h=type[args`repl];'"requires string type as repl"];
 };

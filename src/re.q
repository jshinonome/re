.re.path:` sv(first ` vs hsym `$first -3#value{}),`re2;
.re:(.re.path 2:(`libre2;1))`;
.re:((enlist `)!enlist (::)),.re;

.re.MatchGroups:{[pattern;texts]
  .re.validateArgs[`pattern`texts!(pattern;texts)];
  .re.matchGroups[pattern;texts]
 };

.re.Replace:{[pattern;texts;repl]
  .re.validateArgs[`pattern`texts`repl!(pattern;texts;repl)];
  .re.replace[pattern;texts;repl]
 };

.re.ReplaceAll:{[pattern;texts;repl]
  .re.validateArgs[`pattern`texts`repl!(pattern;texts;repl)];
  .re.replaceAll[pattern;texts;repl]
 };

.re.IsMatch:{[pattern;texts]
  .re.validateArgs[`pattern`texts!(pattern;texts)];
  .re.isPartialMatch[pattern;texts]
  };

.re.IsFullMatch:{[pattern;texts]
  .re.validateArgs[`pattern`texts!(pattern;texts)];
  .re.isFullMatch[pattern;texts]
 };

.re.validateArgs:{[args]
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

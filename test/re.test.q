import{"../src/re.q"};

// test full match
.kest.Test["full match a string";{
  .re.IsFullMatch["\\d{4}";"9999"]
 }];

.kest.Test["full match strings";{
  .kest.Match[110b;.re.IsFullMatch["\\d{4}";("9999";"1234";"111")]]
 }];

.kest.Test["full match a symbol";{
  .re.IsFullMatch["\\d{4}";`9999]
 }];

.kest.Test["full match symbols";{
  .kest.Match[110b;.re.IsFullMatch["\\d{4}";(`9999`1234`111)]]
 }];

// test match
.kest.Test["match a string";{
  .re.IsMatch["\\d{4}";"99999"]
 }];

.kest.Test["match strings";{
  .kest.Match[110b;.re.IsMatch["\\d{4}";("99999";"1234";"111")]]
 }];

.kest.Test["match a symbol";{
  .re.IsMatch["\\d{4}";`99999]
 }];

.kest.Test["match symbols";{
  .kest.Match[110b;.re.IsMatch["\\d{4}";(`99999`1234`111)]]
 }];

.kest.Test["match empty list";{
  (`boolean$())~.re.IsMatch["\\d{4}";()]
 }];

.kest.Test["match empty symbol list";{
  (`boolean$())~.re.IsMatch["\\d{4}";`$()]
 }];

// test replace all
.kest.Test["replace all of a string";{
  .kest.Match["99";.re.ReplaceAll["\\d{2}";"9999";1#"9"]]
 }];

.kest.Test["replace all of strings";{
  .kest.Match[("999";"99";"91");.re.ReplaceAll["\\d{2}";("99999";"1234";"111");1#"9"]]
 }];

.kest.Test["replace all of a symbol";{
  .kest.Match[`99;.re.ReplaceAll["\\d{2}";`9999;1#"9"]]
 }];

.kest.Test["replace all of symbols";{
  .kest.Match[(`999`99`91);.re.ReplaceAll["\\d{2}";(`99999`1234`111);1#"9"]]
 }];

// test replace
.kest.Test["replace first match of a string";{
  .kest.Match["999";.re.Replace["\\d{2}";"9999";1#"9"]]
 }];

.kest.Test["replace first match of strings";{
  .kest.Match[("9999";"934";"91");.re.Replace["\\d{2}";("99999";"1234";"111");1#"9"]]
 }];

.kest.Test["replace first match of a symbol";{
  .kest.Match[`999;.re.Replace["\\d{2}";`9999;1#"9"]]
 }];

.kest.Test["replace first match of symbols";{
  .kest.Match[`9999`934`91;.re.Replace["\\d{2}";`99999`1234`111;1#"9"]]
 }];

// test match error
.kest.Test["bad pattern";{
   .kest.ToThrow[(.re.IsMatch;"\\d[";"99999");"re2-bad regex - missing ]: ["]
 }];

.kest.Test["bad texts";{
   .kest.ToThrow[(.re.IsMatch;"\\d[";1);"requires string(s) or symbol(s) as texts"]
 }];

.kest.Test["bad repl";{
  .kest.ToThrow[
    (.re.Replace;"\\d{2}";`99999`1234`111;`9);
    "requires string type as repl"]
 }];

// test match groups
.kest.Test["match groups of a string without named groups";{
  .kest.Match[
    `group0`group1`group2!("@one-punch-man/";"saitama";"0.0.1");
    .re.MatchGroups[
      "(@[a-z-]+/)?([a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      "@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["match groups of a string with named group";{
  .kest.Match[
    `scope`package`version!("@one-punch-man/";"saitama";"0.0.1");
    .re.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@(?P<version>[0-9]+\\.[0-9]+\\.[0-9]+))?";
      "@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["match groups of a string with mixed named group";{
  .kest.Match[
    `scope`package`group2!("@one-punch-man/";"saitama";"0.0.1");
    .re.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      "@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["partial match groups of a string with mixed named group";{
  .kest.Match[
    `scope`package`group2!("";"saitama";"0.0.1");
    .re.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      "saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["match groups of string list with mixed named group";{
  .kest.Match[
    `group0`exchange!(("4912";"4921";"8252";"");(1#"T";1#"T";"CHI";""));
    .re.MatchGroups[
      "(\\d{4})(?:\\.(?P<exchange>\\w+))";
      ("4912.T";"4921.T";"8252.CHI";"")
    ]
  ]
 }];

.kest.Test["match groups of empty string list with mixed named group";{
  .kest.Match[
    `group0`exchange!(();());
    .re.MatchGroups[
      "(\\d{4})(?:\\.(?P<exchange>\\w+))";
      ()
    ]
  ]
 }];

.kest.Test["match groups of symbol list with mixed named group";{
  .kest.Match[
    `group0`exchange!((`4912`4921`8252`);(`T`T`CHI`));
    .re.MatchGroups[
      "(\\d{4})(?:\\.(?P<exchange>\\w+))";
      `4912.T`4921.T`8252.CHI`
    ]
  ]
 }];

.kest.Test["match groups of empty symbol list with mixed named group";{
  .kest.Match[
    `group0`exchange!(`$();`$());
    .re.MatchGroups[
      "(\\d{4})(?:\\.(?P<exchange>\\w+))";
      `$()
    ]
  ]
 }];

.kest.Test["match groups of a symbol without named groups";{
  .kest.Match[
    `group0`group1`group2!`$("@one-punch-man/";"saitama";"0.0.1");
    .re.MatchGroups[
      "(@[a-z-]+/)?([a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      `$"@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["match groups of a symbol with named group";{
  .kest.Match[
    `scope`package`version!`$("@one-punch-man/";"saitama";"0.0.1");
    .re.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@(?P<version>[0-9]+\\.[0-9]+\\.[0-9]+))?";
      `$"@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["match groups of a symbol with mixed named group";{
  .kest.Match[
    `scope`package`group2!`$("@one-punch-man/";"saitama";"0.0.1");
    .re.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      `$"@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["partial match groups of a symbol with mixed named group";{
  .kest.Match[
    `scope`package`group2!`$("";"saitama";"0.0.1");
    .re.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      `$"saitama@0.0.1"
    ]
  ]
 }];

// test match groups error
.kest.Test["no match group error";{
  .kest.ToThrow[
    (
      .re.MatchGroups;
      "[a-z-]+";
      "saitama"
    );
    "re2-no group found"
  ]
 }];

.kest.Test["too many groups error";{
  .kest.ToThrow[
    (
      .re.MatchGroups;
      "(0)(1)(2)(3)(4)(5)(6)(7)(8)(9)(10)";
      "saitama"
    );
    "re2-too many groups(>10)"
  ]
 }];

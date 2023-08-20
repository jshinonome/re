import{"../src/re2.q"};

// test full match
.kest.Test["test full match a string";{
  .re2.FullMatch["\\d{4}";"9999"]
 }];

.kest.Test["test full match strings";{
  .kest.Match[110b;.re2.FullMatch["\\d{4}";("9999";"1234";"111")]]
 }];

.kest.Test["test full match a symbol";{
  .re2.FullMatch["\\d{4}";`9999]
 }];

.kest.Test["test full match symbols";{
  .kest.Match[110b;.re2.FullMatch["\\d{4}";(`9999`1234`111)]]
 }];

// test match
.kest.Test["test match a string";{
  .re2.Match["\\d{4}";"99999"]
 }];

.kest.Test["test match strings";{
  .kest.Match[110b;.re2.Match["\\d{4}";("99999";"1234";"111")]]
 }];

.kest.Test["test match a symbol";{
  .re2.Match["\\d{4}";`99999]
 }];

.kest.Test["test match symbols";{
  .kest.Match[110b;.re2.Match["\\d{4}";(`99999`1234`111)]]
 }];

.kest.Test["test match empty list";{
  (`boolean$())~.re2.Match["\\d{4}";()]
 }];

.kest.Test["test match empty symbol list";{
  (`boolean$())~.re2.Match["\\d{4}";`$()]
 }];

// test replace all
.kest.Test["test replace all of a string";{
  .kest.Match["99";.re2.ReplaceAll["\\d{2}";"9999";1#"9"]]
 }];

.kest.Test["test replace all of strings";{
  .kest.Match[("999";"99";"91");.re2.ReplaceAll["\\d{2}";("99999";"1234";"111");1#"9"]]
 }];

.kest.Test["test replace all of a symbol";{
  .kest.Match[`99;.re2.ReplaceAll["\\d{2}";`9999;1#"9"]]
 }];

.kest.Test["test replace all of symbols";{
  .kest.Match[(`999`99`91);.re2.ReplaceAll["\\d{2}";(`99999`1234`111);1#"9"]]
 }];

// test replace
.kest.Test["test replace first match of a string";{
  .kest.Match["999";.re2.Replace["\\d{2}";"9999";1#"9"]]
 }];

.kest.Test["test replace first match of strings";{
  .kest.Match[("9999";"934";"91");.re2.Replace["\\d{2}";("99999";"1234";"111");1#"9"]]
 }];

.kest.Test["test replace first match of a symbol";{
  .kest.Match[`999;.re2.Replace["\\d{2}";`9999;1#"9"]]
 }];

.kest.Test["test replace first match of symbols";{
  .kest.Match[`9999`934`91;.re2.Replace["\\d{2}";`99999`1234`111;1#"9"]]
 }];

// test match error
.kest.Test["test bad pattern";{
   .kest.ToThrow[(.re2.Match;"\\d[";"99999");"re2-bad regex - missing ]: ["]
 }];

.kest.Test["test bad texts";{
   .kest.ToThrow[(.re2.Match;"\\d[";1);"requires string(s) or symbol(s) as texts"]
 }];

.kest.Test["test bad repl";{
  .kest.ToThrow[
    (.re2.Replace;"\\d{2}";`99999`1234`111;`9);
    "requires string type as repl"]
 }];

// test match groups
.kest.Test["test match groups of a string without named groups";{
  .kest.Match[
    `group0`group1`group2!("@one-punch-man/";"saitama";"0.0.1");
    .re2.MatchGroups[
      "(@[a-z-]+/)?([a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      "@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["test match groups of a string with named group";{
  .kest.Match[
    `scope`package`version!("@one-punch-man/";"saitama";"0.0.1");
    .re2.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@(?P<version>[0-9]+\\.[0-9]+\\.[0-9]+))?";
      "@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["test match groups of a string with mixed named group";{
  .kest.Match[
    `scope`package`group2!("@one-punch-man/";"saitama";"0.0.1");
    .re2.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      "@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["test partial match groups of a string with mixed named group";{
  .kest.Match[
    `scope`package`group2!("";"saitama";"0.0.1");
    .re2.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      "saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["test match groups of a symbol without named groups";{
  .kest.Match[
    `group0`group1`group2!`$("@one-punch-man/";"saitama";"0.0.1");
    .re2.MatchGroups[
      "(@[a-z-]+/)?([a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      `$"@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["test match groups of a symbol with named group";{
  .kest.Match[
    `scope`package`version!`$("@one-punch-man/";"saitama";"0.0.1");
    .re2.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@(?P<version>[0-9]+\\.[0-9]+\\.[0-9]+))?";
      `$"@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["test match groups of a symbol with mixed named group";{
  .kest.Match[
    `scope`package`group2!`$("@one-punch-man/";"saitama";"0.0.1");
    .re2.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      `$"@one-punch-man/saitama@0.0.1"
    ]
  ]
 }];

.kest.Test["test partial match groups of a symbol with mixed named group";{
  .kest.Match[
    `scope`package`group2!`$("";"saitama";"0.0.1");
    .re2.MatchGroups[
      "(?P<scope>@[a-z-]+/)?(?P<package>[a-z-]+)(?:@([0-9]+\\.[0-9]+\\.[0-9]+))?";
      `$"saitama@0.0.1"
    ]
  ]
 }];

// test match groups error
.kest.Test["test no match group error";{
  .kest.ToThrow[
    (
      .re2.MatchGroups;
      "[a-z-]+";
      "saitama"
    );
    "re2-no group found"
  ]
 }];

.kest.Test["test too many groups error";{
  .kest.ToThrow[
    (
      .re2.MatchGroups;
      "(0)(1)(2)(3)(4)(5)(6)(7)(8)(9)(10)";
      "saitama"
    );
    "re2-too many groups(>10)"
  ]
 }];

## Re2

A kdb+/q wrapper of [google/re2,tag:2023-03-01](https://github.com/google/re2)

- .re.IsMatch
- .re.IsFullMatch
- .re.Replace
- .re.ReplaceAll
- .re.MatchGroups

Reference:

- [jfenton/qre2](https://github.com/jfenton/qre2)

> Have to use tag:2023-03-01 for google/re2, as abseil seems not to be supported by kdb

### C++ Compiler Requirements

```
gcc >= 13.2.1
libstdc++.x86_64 >= 13.2.1
libstdc++-devel.x86_64 >= 13.2.1
libstdc++-static.x86_64 >= 13.2.1
```

### Installation

```
kuki --install re2
```

### Examples

```q
import{"re2/re2.q"};

// 110b
.re.IsFullMatch["\\d{4}";(`9999`1234`111)]

// 110b
.re.IsMatch["\\d{4}";`99999`1234`111]

// "999"
.re.Replace["\\d{2}";"9999";1#"9"]

// `999`99`91
.re.ReplaceAll["\\d{2}";`99999`1234`111;1#"9"]

// `group0`exchange!((`4912`4921`8252`);(`T`T`CHI`))
.re.MatchGroups["(\\d{4})(?:\\.(?P<exchange>\\w+))";`4912.T`4921.T`8252.CHI`]
```

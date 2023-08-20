## Re2

A wrapper of [google/re2,tag:2023-03-01](https://github.com/google/re2) for kdb+/q

- .re2.IsMatch
- .re2.IsFullMatch
- .re2.Replace
- .re2.ReplaceAll
- .re2.MatchGroups

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

###

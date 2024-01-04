$$
D_\texttt{r}(\texttt{"regex-swift"})
$$

## Overview

`egex-derivative` is a swift package that implements regex derivatives.
These derivatives operate on a character basis. If a character matches it is consumed
and the remainder of the string is returned; otherwise, `nil` is returned.

```swift
D("a")("abc").0 == "bc"
D("a")("xyz").0 == nil
```

Derivatives compose:

```swift
(D("a") .. D("b"))("abc").0 == "c"
```

There are also the standard quantification operators:

```swift
(D("a")*)("aaaa") == ""
(D("x")~)("abc") == "abc
```

Alongside alternation:

```swift
((D("a")..D("b")..D("c"))|(D("x")..D("y")..D("z")))("xy") == "z"
```

This leads to the observation that a regex matcher can be constructed by composing
these derivatives. The matcher succeeds if it consumes the string and returns `""`;
otherwise, it fails to match by returning `nil`.

## Extras

This package returns the AST of the regex composed from derivatives:

```
((D("a")..D("b")..D("c"))|(D("y")*))("a").1
// Produces an AST of the _match_ of the form (WIP: Eliminate need for match)
```

Prettyprint the derivative with `"\(RegexDerivative)"`.

The partial matcher of a regex (as defined [here](https://github.com/capricorn/ssregex-tex)) is
available via `partial(flatten(RegexDerivative.1))`.

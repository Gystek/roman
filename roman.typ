#import "@preview/numbly:0.1.0": numbly

#set page(paper: "a4", columns: 2)
#set par(first-line-indent: 1em, justify: true)
#set text(font: "Tex Gyre Termes", size: 11pt)
#show math.equation: set text(
  font: ("Cambria Math"),
)
#set heading(
  numbering: numbly(
    "{1:I}.",
    "{2}.",
  ),
)

#show link: set text(fill: blue, weight: 700)
#show link: underline

#place(top + center,
  float: true,
  scope: "parent",
  clearance: 2em, [
#align(center, text(15pt)[
  *Conversionless Mathematical Operations on Roman Numerals*
])
#align(center, text(13pt)[
    Gustek
])
#align(center, [October 17, 2025])
])

= Introduction

This paper presents algorithms to compute the result of basic mathematical operations
on Roman numerals without converting them to (and then from) base 10 numbers.

= Addition

Let us define a function $M =$ {(#smallcaps([iv]), #smallcaps([iiii])); 
(#smallcaps([ix]), #smallcaps([viiii])); (#smallcaps([xl]), #smallcaps([xxxx]));
(#smallcaps([xc]), #smallcaps([lxxxx])); (#smallcaps([cd]), #smallcaps([cccc]));
(#smallcaps([cm]),#smallcaps([dcccc]))) and $E =$
(#smallcaps([iiiii]), #smallcaps([v])); (#smallcaps([vv]), #smallcaps([x]));
(#smallcaps([xxxxx]), #smallcaps([l])); (#smallcaps([ll]), #smallcaps([c]));
(#smallcaps([ccccc]), #smallcaps([d])); (#smallcaps([dd]), #smallcaps([m]))}
with $M(x) = x$ and $E(x) = x$ for all other values. $tilde(M)$ is defined as
$tilde(M)(x) = x #text([if $M(x) = x$])$ and $tilde(M)(x) = tilde(M)(M(x))$ else.
$tilde(E)$ is defined in a similar fashion.

The algorithm to compute $z = x + y$ is as follows:
#table(
  columns: (auto, auto),
  stroke: none,
  [1],
  $x' <- tilde(M)(x)$,
  [2],
  $y' <- tilde(M)(y)$,
  [3],
  $z' <- g r o u p(c a t(x, y))$,
  [4],
  $z <- tilde(M)^(-1)(tilde(E)(z'))$
)

Where $c a t$ is the concatenation function and $g r o u p$ groups individual components
of a number together. We describe the operation of the algorithm for the computation of
$z = #smallcaps([xlix]) + #smallcaps([lxi])$ (49 + 61):

#table(
  columns: (auto, auto),
  stroke: none,
  table.header(
    [operation], [line]
  ),
  $x' <- M(#smallcaps([xlix])) = #smallcaps([xxxxviiii])$,
  [1],
  $y' <- M(#smallcaps([lxi])) = #smallcaps([lxi])$,
  [2],
  $c a t(#smallcaps([xxxxviiii]), #smallcaps([lxi])) = #smallcaps([xxxxviiii.lxi])$,
  [3],
  $z' <- g r o u p (#smallcaps([xxxxviiii.lxi])) = #smallcaps([lxxxxxviiiii])$,
  [3],
  $E(#smallcaps([lxxxxxviiiii])) = #smallcaps([llvv])$,
  [4],
  $z <- E(#smallcaps([llvv])) = #smallcaps([cx])$,
  [4]
)

We thus get $z <- #smallcaps([cx])$ (110).

= Substraction

The algorithm for substraction is slightly more complex than the one for addition,
as it involves more conditional expansions/reductions. The algorithm to compute
$z = x - y$ where $x > y$ (where $>$ is the natural order on Roman numerals) is
setup by defining $x'$ and $y'$ to be respectively $tilde(M)(x)$ and $tilde(M)(y)$.
Let the function $v(x)$ turn a Roman numeral $d_1d_2...d_n$ into
the vector $(d_1, d_2, ..., d_n)$. We also define $overline(x) = v(x')$ and
$overline(y) = v(y')$. The core of the algorithm is as follows:
#table(
  columns: (auto, auto),
  align: (right, auto),
  stroke: none,
  [1],
  [while $overline(y) != ()$],
  [2],
  [--- $m_x <- min(overline(x))$],
  [3],
  [--- $m_y <- min(overline(y))$],
  [4],
  [--- if $m_y in overline(x)$],
  [5],
  [------ $overline(y) <- overline(y) - m_y$],
  [6],
  [------ $overline(x) <- overline(x) - m_y$],
  [7],
  [--- else if $m_y < m_x$],
  [8],
  [------ $overline(x) <- E^(-1)(overline(x))$],
  [9],
  [--- else],
  [10],
  [------ if $E(overline(x)) != overline(x)$],
  [11],
  [--------- $overline(x) <- E(overline(x))$],
  [12],
  [------ else],
  [13],
  [--------- $overline(y) <- E^(-1)(overline(y))$],
  [14],
  [$z <- tilde(M)^(-1)(tilde(E)(overline(x)))$]
)

We describe the operation of the algorithm for the computation of
$z = #smallcaps([xx]) - #smallcaps([xviii])$ (20 - 18). We thus have
$overline(x) = (#smallcaps([x]), #smallcaps([x]))$ and $overline(y) =
(#smallcaps([x]), #smallcaps([v]), #smallcaps([i]), #smallcaps([i]), #smallcaps([i]))$.
We write the vectors as standard numerals for the sake of conciseness. The algorithms
runs as follows:
#table(
  columns: (auto, auto, auto, auto),
  stroke: none,
  table.header(
    [operation], $m_x$, $m_y$, [line]
  ),
  $overline(x) <- E^(-1)(#smallcaps([xx])) = #smallcaps([vvvv])$, [#smallcaps([x])],
  [#smallcaps([i])], [8],
  $overline(x) <- E^(-1)(#smallcaps([vvvv])) = #smallcaps([20i])$, [#smallcaps([v])],
  [#smallcaps([i])], [8],
  $overline(y) <- #smallcaps([xvii])$, [#smallcaps([i])], [#smallcaps([i])], [5],
  $overline(x) <- #smallcaps([19i])$, [#smallcaps([i])], [#smallcaps([i])], [6],
  $overline(y) <- #smallcaps([xvi])$, [#smallcaps([i])], [#smallcaps([i])], [5],
  $overline(x) <- #smallcaps([18i])$, [#smallcaps([i])], [#smallcaps([i])], [6],
  $overline(y) <- #smallcaps([xv])$, [#smallcaps([i])], [#smallcaps([i])], [5],
  $overline(x) <- #smallcaps([17i])$, [#smallcaps([i])], [#smallcaps([i])], [6],
  $overline(x) <- #smallcaps([vvvii])$, [#smallcaps([i])], [#smallcaps([v])], [11],
  $overline(y) <- #smallcaps([x])$, [#smallcaps([v])], [#smallcaps([v])], [5],
  $overline(x) <- #smallcaps([vvii])$, [#smallcaps([v])], [#smallcaps([v])], [6],
  $overline(x) <- #smallcaps([xii])$, [#smallcaps([v])], [#smallcaps([x])], [11],
  $overline(y) <- ()$, [#smallcaps([x])], [#smallcaps([x])], [5],
  $overline(x) <- #smallcaps([ii])$, [#smallcaps([x])], [#smallcaps([x])], [6],
  $z <- #smallcaps([ii])$, [#smallcaps([i])], [], [14],
)

We thus get $z <- #smallcaps([ii])$ (2).

= Multiplication

Roman numerals multiplication can be achieved through matrix multiplication of
digits vectors. The algorithm to compute $z = x y$ is as follows:
#table(
  columns: (auto, auto),
  stroke: none,
  [1],
  $x' <- tilde(M)(x)$,
  [2],
  $y' <- tilde(M)(y)$,
  [3],
  $overline(x) <- v(x')$,
  [4],
  $overline(y) <- v(y')$,
  [5],
  $overline(z) <- overline(x) times overline(y)^tack.t$,
  [6],
  $z' <- g r o u p(c a t(overline(z)))$,
  [7],
  $z <- tilde(M)^(-1)(tilde(E)(z'))$
)

The matrix product on line 5 uses the following $pi$ function for component multiplication:
#table(
  columns: (auto, auto, auto, auto, auto, auto, auto, auto),
  stroke: none,
  table.header(
    [], [#smallcaps([i])], [#smallcaps([v])], [#smallcaps([x])],
        [#smallcaps([l])], [#smallcaps([c])], [#smallcaps([d])],
        [#smallcaps([m])]
  ),
  [#smallcaps([i])], [#smallcaps([i])], [#smallcaps([v])], [#smallcaps([x])],
                     [#smallcaps([l])], [#smallcaps([c])], [#smallcaps([d])],
                     [#smallcaps([m])],
  [#smallcaps([v])], [#smallcaps([v])], [#smallcaps([xxv])], [#smallcaps([l])],
                     [#smallcaps([ccl])], [#smallcaps([d])], [#smallcaps([mmd])],
                     [#smallcaps([5m])],
  [#smallcaps([x])], [#smallcaps([x])], [#smallcaps([l])], [#smallcaps([c])],
                     [#smallcaps([d])], [#smallcaps([m])], [#smallcaps([5m])],
                     [#smallcaps([10m])],
  [#smallcaps([l])], [#smallcaps([l])], [#smallcaps([ccl])], [#smallcaps([d])],
                     [#smallcaps([mmd])], [#smallcaps([5m])], [#smallcaps([25m])],
                     [#smallcaps([50m])],
  [#smallcaps([c])], [#smallcaps([c])], [#smallcaps([d])], [#smallcaps([m])],
                     [#smallcaps([5m])], [#smallcaps([10m])], [#smallcaps([50m])],
                     [#smallcaps([100m])],
  [#smallcaps([d])], [#smallcaps([d])], [#smallcaps([mmd])], [#smallcaps([5m])],
                     [#smallcaps([25m])], [#smallcaps([50m])], [#smallcaps([250m])],
                     [#smallcaps([500m])],
  [#smallcaps([m])], [#smallcaps([m])], [#smallcaps([5m])], [#smallcaps([10m])],
                     [#smallcaps([50m])], [#smallcaps([100m])], [#smallcaps([500m])],
                     [#smallcaps([1000m])]
)

We describe the operation of the algorithm for the computation of $z = 
#smallcaps([xliii]) dot #smallcaps([xii])$ (43 $dot$ 12):

#table(
  columns: (auto, auto),
  stroke: none,
  table.header(
    [operation], [line]
  ),
  $x' <- M(#smallcaps([xliii])) = #smallcaps([xxxxiii])$,
  [1],
  $y' <- M(#smallcaps([xii])) = #smallcaps([xii]) $,
  [2],
  $overline(x) <- (#smallcaps([x]), #smallcaps([x]), #smallcaps([x]), #smallcaps([x]),
  #smallcaps([i]), #smallcaps([i]), #smallcaps([i]))$,
  [3],
  $overline(y) <- (#smallcaps([x]), #smallcaps([i]), #smallcaps([i]))$,
  [4],
  $overline(z) <- overline(y)^tack.t times overline(x) =
  mat(
    c, c, c, c, x, x, x;
    x, x, x, x, i, i, i;
    x, x, x, x, i, i, i;
  )$,
  [5],
  $c a t(overline(z)) = #smallcaps([ccccxxx.xxxxiii.xxxxiii])$,
  [6],
  $z' <- g r o u p(#smallcaps([ccccxxx.xxxxiii.xxxxiii])) = #smallcaps([ccccxxxxxxxxxxxiiiiii])$,
  [6],
  $E(#smallcaps([ccccxxxxxxxxxxxiiiiii])) = #smallcaps([ccccllxvi])$,
  [7],
  $E(#smallcaps([ccccllxvi])) = #smallcaps([cccccxvi])$,
  [7],
  $z <- E(#smallcaps([cccccxvi])) = #smallcaps([dxvi])$,
  [7]
)

We thus get $z <- #smallcaps([dxvi])$ (516).

= Division

We do not define a specific algorithm for (Euclidean) division here, as it can
be reduced to substractions and the introduction of a trivial order on Roman numerals.

/// This program is an implementation of the algorithms described in the
/// paper entitled "Conversionless Mathematical Operations on Roman
/// Numerals" by Gustek.
///
/// It it invoked as follows:
///     program <lhs> <op> <rhs>
///
/// where LHS and RHS are Roman numerals and OP is one of `+`, `-` and `*`.
use std::{cmp::Ordering, env, process::exit};

fn maximize(s: &str) -> String {
    s.replace("iv", "iiii")
        .replace("ix", "viiii")
        .replace("xl", "xxxx")
        .replace("xc", "lxxxx")
        .replace("cd", "cccc")
        .replace("cm", "dcccc")
}

fn minimize(s: &str) -> String {
    s.replace("dcccc", "cm")
        .replace("cccc", "cd")
        .replace("lxxxx", "xc")
        .replace("xxxx", "xl")
        .replace("viiii", "ix")
        .replace("iiii", "iv")
}

fn expand(s: &str) -> String {
    s.replace("v", "iiiii")
        .replace("x", "vv")
        .replace("l", "xxxxx")
        .replace("c", "ll")
        .replace("d", "ccccc")
        .replace("m", "dd")
}

fn reduce(s: &str) -> String {
    s.replace("dd", "m")
        .replace("ccccc", "d")
        .replace("ll", "c")
        .replace("xxxxx", "l")
        .replace("vv", "x")
        .replace("iiiii", "v")
}

fn gen_all(s: &str, f: fn(&str) -> String) -> String {
    let ms = f(s);

    if s == ms {
        ms
    } else {
        gen_all(&ms, f)
    }
}

fn maximize_all(s: &str) -> String {
    gen_all(s, maximize)
}

fn minimize_all(s: &str) -> String {
    gen_all(s, minimize)
}

fn reduce_all(s: &str) -> String {
    gen_all(s, reduce)
}

fn roman_order(x: char, y: char) -> Ordering {
    match (x, y) {
        ('i', 'i') => Ordering::Equal,
        ('i', _) => Ordering::Less,
        (_, 'i') => Ordering::Greater,
        ('v', 'v') => Ordering::Equal,
        ('v', _) => Ordering::Less,
        (_, 'v') => Ordering::Greater,
        ('x', 'x') => Ordering::Equal,
        ('x', _) => Ordering::Less,
        (_, 'x') => Ordering::Greater,
        ('l', 'l') => Ordering::Equal,
        ('l', _) => Ordering::Less,
        (_, 'l') => Ordering::Greater,
        ('c', 'c') => Ordering::Equal,
        ('c', _) => Ordering::Less,
        (_, 'c') => Ordering::Greater,
        ('d', 'd') => Ordering::Equal,
        ('d', _) => Ordering::Less,
        (_, 'd') => Ordering::Greater,
        ('m', 'm') => Ordering::Equal,
        (_, _) => unreachable!(),
    }
}

fn group(s: &str) -> String {
    let mut c = s.chars().collect::<Vec<char>>();

    c.sort_by(|&x, &y| roman_order(x, y));

    c.into_iter().rev().collect::<String>()
}

fn minimum(x: &str) -> Option<(char, usize)> {
    x.chars().enumerate().fold(None, |m, (i, c)| match m {
        Some((b, _)) => match roman_order(b, c) {
            Ordering::Greater => Some((c, i)),
            _ => m,
        },
        None => Some((c, i)),
    })
}

fn addition(x: &str, y: &str) -> String {
    let mut xp = maximize_all(x);
    let yp = maximize_all(y);

    xp.push_str(&yp);

    minimize_all(&reduce_all(&group(&xp)))
}

fn substraction(x: &str, y: &str) -> String {
    let mut xp = maximize_all(x);
    let mut yp = maximize_all(y);

    while let Some((my, yi)) = minimum(&yp) {
        let (mx, _) = minimum(&xp).unwrap();

        if let Some(xi) = xp.find(my) {
            xp.remove(xi);
            yp.remove(yi);
        } else if roman_order(my, mx) == Ordering::Less {
            xp = expand(&xp);
        } else {
            let nx = reduce(&xp);

            if nx == xp {
                yp = expand(&yp);
            } else {
                xp = nx;
            }
        }
    }

    minimize_all(&reduce_all(&xp))
}

fn pi(x: char, y: char) -> String {
    match (x, y) {
	('i', _) => String::from(y),
	('v', 'v') => String::from("xxv"),
	('v', 'x') => String::from("l"),
	('v', 'l') => String::from("ccl"),
	('v', 'c') => String::from("d"),
	('v', 'd') => String::from("mmd"),
	('v', 'm') => String::from("mmmmm"),
	('x', 'x') => String::from("c"),
	('x', 'l') => String::from("d"),
	('x', 'c') => String::from("m"),
	('x', 'd') => String::from("mmmmm"),
	('x', 'm') => String::from("mmmmmmmmmm"),
	('l', 'l') => String::from("mmd"),
	('l', 'c') => String::from("mmmmm"),
	('l', 'd') => String::from("mmmmmmmmmmmmmmmmmmmmmmmmm"),
	('l', 'm') => String::from("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"),
	('c', 'c') => String::from("mmmmmmmmmm"),
	('c', 'd') => String::from("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"),
	('c', 'm') => String::from("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"),
	('d', 'd') => String::from("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"),
	('d', 'm') => String::from("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"),
	('m', 'm') => String::from("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"),
	_ => pi(y, x),
    }
}

fn multiplication(x: &str, y: &str) -> String {
    let xp = maximize_all(x);
    let yp = maximize_all(y);

    let mut zp = String::with_capacity(xp.len() * yp.len());

    for a in xp.chars().into_iter() {
	for b in (&yp).chars() {
	    zp.push_str(&pi(a, b));
	}
    }

    minimize_all(&reduce_all(&group(&zp)))
}

fn main() {
    let args = env::args().collect::<Vec<String>>();

    if args.len() != 4 {
        eprintln!("usage: {} <lhs> <op> <rhs>", args[0]);

        exit(1);
    }

    println!(
        "{}",
        match args[2].as_str() {
            "+" => addition(&args[1], &args[3]),
            "-" => substraction(&args[1], &args[3]),
	    "*" => multiplication(&args[1], &args[3]),
            _ => {
                eprintln!("unknown operator: `{}`", args[2]);
                exit(1);
            }
        }
    );
}

String extend [
    split: bySeparator [
        ^((self tokenize: (bySeparator escapeRegex)) collect: [:item | item trimSeparators]) select: [:str| (str size) > 0]
    ]
]

Object extend [
    parseLine: line [
        |winningNumbersAndCardNumbers cardNumbers winningNumbers cardIdAndWinningNumbers|
        winningNumbersAndCardNumbers := line split: '|'.

        cardNumbers := ((winningNumbersAndCardNumbers second) split: ' ') collect: [:num| num asNumber].
        
        cardIdAndWinningNumbers := (winningNumbersAndCardNumbers first) split: ':'.
        winningNumbers := ((cardIdAndWinningNumbers second) split: ' ') collect: [:num| num asNumber].        
        ^(Array with: winningNumbers with: cardNumbers).
    ]
]


Object subclass: Part1 [
    solution: inStream [
        |winningNumbers cardNumbers winningCount total parsedLine|
        total := 0.

        (inStream lines) do: [:line|
            
            parsedLine := (self parseLine: line).

            winningNumbers := parsedLine first.
            cardNumbers := parsedLine second.
            

            winningCount := winningNumbers count: [:num|
                (cardNumbers includes: num)
            ].

            total := total + (1 bitShift: (winningCount - 1)).
        ].

        ^total
    ]
]

Object subclass: Part2 [
    solution: inStream [
        |cards matchingTable howManyCards totalSum|
        totalSum := 0.

        cards := OrderedCollection new.
        (inStream lines) do: [:line|
            cards add: (self parseLine: line).
        ].

        howManyCards := (cards size).
        matchingTable := Array new: howManyCards withAll: 1.

        (cards reverse) keysAndValuesDo: [:i :card|
            |count reverseI|
            count := (card first) count: [:num|
                ((card second) includes: num)
            ].
            
            reverseI := howManyCards - (i - 1).

            1 to: count do: [:k|
                matchingTable at: reverseI put: (matchingTable at: reverseI) + (matchingTable at: reverseI + k)
            ].

            totalSum := totalSum + (matchingTable at: reverseI)
        ].

        ^totalSum.
    ]
]


Eval [
    |part1 part2 f|

    f := FileStream open: './input.txt'.

    ((Part1 new) solution: f) printNl.

    f position: 0.

    ((Part2 new) solution: f) printNl.
]
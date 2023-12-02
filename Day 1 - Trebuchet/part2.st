String extend [
    calibrationValue [
        | spelledDigits transformedStr firstDigit lastDigit |

        spelledDigits := Dictionary from: {
            'one' -> 'o1e'.
            'two' -> 't2o'.
            'three' -> 't3e'.
            'four' -> '4'.
            'five' -> '5e'.
            'six' -> '6'.
            'seven' -> '7n'.
            'eight' -> 'e8t'.
            'nine' -> 'n9e'
        }.

        transformedStr := (spelledDigits associations) inject: self into: [
            :acc :current |
            acc copyReplacingAllRegex: (current key) with: current value
        ].

        transformedStr printNl.

        firstDigit := transformedStr detect: [:each | each isDigit].
        lastDigit := transformedStr reverse detect: [:each | each isDigit].

        ^(firstDigit asString), (lastDigit asString)
    ]
]


Eval [
    | calibrationSum |
    calibrationSum := 0.
    f := FileStream open: './input.txt' mode: FileStream read.

    f linesDo: [
        :line |
        calibrationSum := calibrationSum + (line calibrationValue asNumber)
    ].

    calibrationSum printNl
] 
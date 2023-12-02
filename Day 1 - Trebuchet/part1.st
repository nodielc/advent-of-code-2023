String extend [
    findFirstDigit [
        self do: [ :c | c isDigit ifTrue: [ ^c asString ] ]
    ]

    findLastDigit [
        self reverse do: [ :c | c isDigit ifTrue: [^c asString ] ] 
    ]
]


Eval [
    | calibrationSum |
    calibrationSum := 0.
    f := FileStream open: './input.txt' mode: FileStream read.

    f linesDo: [
        :line |
        twoDigitNumber := line findFirstDigit, line findLastDigit.
        calibrationSum := calibrationSum + (twoDigitNumber asNumber) 
    ].

    calibrationSum printNl
] 
Object subclass: Directions [
    for: coordinate maxRow: maxRow maxCol: maxCol [
        |dRow dColumn directions tRow tCol|
        dColumn := #(0 1 1 1 0 -1 -1 -1).
        dRow := #(-1 -1 0 1 1 1 0 -1).
        directions := 8.

        ^((1 to: directions) collect: [:dIndex|
            tRow := (coordinate at: 1) + (dRow at: dIndex).
            tCol := (coordinate at: 2) + (dColumn at: dIndex).

            Array with: tRow with: tCol
        ]) select: [:coords|
            ((coords at: 1) >= 1) & ((coords at: 1) <= maxRow) & ((coords at: 2) >= 1) & ((coords at: 2) <= maxCol)
        ]
    ]
]

OrderedCollection extend [
    row: row column: column [
        |character|
        character := (self at:row) at: column.
        ^character
    ]
]

Object extend [
    inputLines [
        |f|
        f := FileStream open: './input.txt' mode: FileStream read.
        ^(f lines)
    ]

    part1 [
        |sum engine|
        sum := 0.

        engine := OrderedCollection new.

        self inputLines do: [
            :line| 
            engine add: line
        ].

        engine keysAndValuesDo: [:rowIndex :row|
            row allOccurrencesOfRegex: '(\d+)' do: [:matchResult|
                |adjancetToSymbol|

                adjancetToSymbol := (matchResult matchInterval) collect: [:columnIndex| 
                    (Directions new for: (Array with: rowIndex with: columnIndex) maxRow: (row size) maxCol: (engine size)) collect: [:coordinate|
                        |characterAt|
                        characterAt := engine row: (coordinate at: 1) column: (coordinate at: 2).

                        ((characterAt isDigit not) & (characterAt ~= $.))
                    ].
                ].
                
                (adjancetToSymbol anySatisfy: [:digitsAdj| digitsAdj anySatisfy: [:isSymbol| isSymbol]]) ifTrue: [sum := sum + (matchResult match asNumber)].
            ]
        ].

        sum printNl.
    ]

    part2 [
        |parts rowParts gears totalSum|
        
        parts := OrderedCollection new.

        self inputLines do: [:line|
            rowParts := Array new: (line size).

            line allOccurrencesOfRegex: '\d+' do: [:matchResults|
                matchResults matchInterval do: [:matchIndex|
                    rowParts at: matchIndex put: (matchResults match asNumber)
                ]
            ].

            line keysAndValuesDo: [:i :char| (char isDigit not) ifTrue: [rowParts at: i put: char]].

            parts add: rowParts.
        ].

        gears := OrderedCollection new.
        
        parts keysAndValuesDo: [:rowIndex :row|
            1 to: (row size) do: [:column|
                ((row at: column) == $*) ifTrue: [gears add: (Array with: rowIndex with: column)]
            ]
        ].

        totalSum := ((((
        gears collect: [:gearCoord|
            |posToCheck|
            (Directions new for: gearCoord maxRow: ((parts at: 1) size) maxCol: (parts size)) collect: [:eachCoord|
                posToCheck := ((parts at: (eachCoord at: 1)) at: (eachCoord at: 2)).
                posToCheck isNumber ifTrue: [posToCheck] ifFalse: [nil]
            ]
        ]
        ) collect: [:adjacent| Set withAll: adjacent]
        ) select: [:adjacentSet| (adjacentSet size) == 2]
        ) collect: [:adjacentSet| adjacentSet fold: [:acc :current| acc * current]]
        ) fold: [:acc :current| acc + current].

        totalSum printNl.
    ]
]


Eval [
    (Object new) part1.
]
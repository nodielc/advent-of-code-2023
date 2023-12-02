String extend [
    split: bySeparator [
        ^(self tokenize: bySeparator) collect: [:item | item trimSeparators]
    ]

    gameId [
        ^(self split: ' ') at: 2 
    ]

    parseRounds [
        | textRounds roundsAssociations |

        textRounds := self split: ';'.

        roundsAssociations := 
            (textRounds collect: [:textRound | textRound split: ',']) collect: [
                :plays |
                plays collect: [
                    :each | 
                    | amountAndColor | 
                    amountAndColor := each split: ' '. 
                    (amountAndColor at: 2) -> ((amountAndColor at: 1) asNumber)
                ]
            ].

        ^roundsAssociations collect: [
            :eachRound |
            | dict |

            dict := Dictionary from: {'red' -> 0. 'green' -> 0. 'blue' -> 0}.

            eachRound do: [
                :play|
                |color howMany |

                color := play key.
                howMany := play value.

                dict at: color put: ((dict at: color) + howMany).
            ].
            dict
        ]
    ]
]

Eval [
    part1GameIdsSum := 0.
    part2SumOfPowersOfSet := 0.

    f := FileStream open: './input.txt' mode: FileStream read.

    f linesDo: [
        :line |
        | fewestCubesForRound |

        gameAndRounds := line split: ':'.
        game := gameAndRounds at: 1.
        rounds := gameAndRounds at: 2.

        gameId := (game gameId) asNumber.
        roundMappings := rounds parseRounds.
        

        (
            roundMappings allSatisfy: [
                :round |
                ((round at: 'red') <= 12) & ((round at: 'green') <= 13) & ((round at: 'blue') <= 14)
            ]
        ) ifTrue: [part1GameIdsSum := part1GameIdsSum + gameId].

        fewestCubesForRound := Dictionary from: { 'red' -> (SmallInteger smallest). 'green' -> (SmallInteger smallest). 'blue' -> (SmallInteger smallest)}.

        roundMappings do: [
            :round |
            (round associations) do: [
                :colorCount |
                fewestForColor := (fewestCubesForRound at: (colorCount key)) max: (colorCount value).

                fewestCubesForRound at: (colorCount key) put: fewestForColor.
            ]
        ].

        powerOfSet := (fewestCubesForRound values) fold: [:acc :current | acc * current].
        part2SumOfPowersOfSet := part2SumOfPowersOfSet + powerOfSet
    ].

    part1GameIdsSum printNl.
    part2SumOfPowersOfSet printNl.
].

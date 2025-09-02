Class {
	#name : 'BaselineOfGUIFetcher',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGUIFetcher',
	#package : 'BaselineOfGUIFetcher'
}

{ #category : 'baselines' }
BaselineOfGUIFetcher >> baseline: spec [
    <baseline>
    spec for: #common do: [
        spec package: 'HeuristicCompletion-Model-1'.
    ].
]

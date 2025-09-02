Class {
	#name : 'CoTopCreditsSelectorFetcher',
	#superclass : 'CoFetcher',
	#instVars : [
		'astNode',
		'maxCount'
	],
	#category : 'HeuristicCompletion-Model-1',
	#package : 'HeuristicCompletion-Model-1'
}

{ #category : 'accessing' }
CoTopCreditsSelectorFetcher >> astNode [
	^ astNode
]

{ #category : 'accessing' }
CoTopCreditsSelectorFetcher >> astNode: aNode [
	astNode := aNode
]

{ #category : 'enumerating' }
CoTopCreditsSelectorFetcher >> entriesDo: aBlock [

	| snapshots ranked topN |
	"Take a snapshot so we don’t race on the live dict"
	snapshots := LastSeenMessage allLastSeen. "Dictionary{ selectorString -> Dictionary{#credits..#lastSeen..#duration} }" "Rank by credits (desc), then lastSeen (desc) to break ties"
	ranked := (snapshots associations collect: [ :assoc |
			           | payload credits last |
			           payload := assoc value.
			           credits := (payload at: #credits ifAbsent: [ 0 ]) asNumber.
			           last := payload at: #lastSeen ifAbsent: [ DateAndTime unixEpoch ].
			           {
				           assoc key.
				           credits.
				           last } ]) asSortedCollection: [ :a :b |
			          a second = b second
				          ifTrue: [ "newer first" a third > b third ]
				          ifFalse: [ a second > b second ] ].

	topN := ranked first: (self maxCount min: ranked size).

	topN do: [ :triple |
			| sel |
			"Keys were stored as Strings; NECSelectorEntry expects the selector"
			sel := triple first asSymbol.
			aBlock value: (NECSelectorEntry contents: sel node: astNode) ]
]

{ #category : 'accessing' }
CoTopCreditsSelectorFetcher >> maxCount [
	^ maxCount ifNil: [ maxCount := 2 ]
]

{ #category : 'accessing' }
CoTopCreditsSelectorFetcher >> maxCount: anInteger [
	maxCount := anInteger
]

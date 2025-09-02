Class {
	#name : 'CoTopCreditsClassFetcher',
	#superclass : 'CoFetcher',
	#instVars : [
		'astNode',
		'maxCount'
	],
	#category : 'HeuristicCompletion-Model-1-Class',
	#package : 'HeuristicCompletion-Model-1',
	#tag : 'Class'
}

{ #category : 'accessing' }
CoTopCreditsClassFetcher >> astNode [

	^ astNode
]

{ #category : 'accessing' }
CoTopCreditsClassFetcher >> astNode: anObject [

	astNode := anObject
]

{ #category : 'enumerating' }
CoTopCreditsClassFetcher >> entriesDo: aBlock [
	| snapshots ranked topN |
	"Take a snapshot so we don’t mutate the live dict"
	snapshots := LastSeenClass allLastSeen. "Dictionary{ classNameString -> {#credits..#lastSeen..#duration} }"

	"Rank by credits desc, then lastSeen desc"
	ranked := (snapshots associations
		collect: [ :assoc | | payload credits last |
			payload := assoc value.
			credits := (payload at: #credits ifAbsent: [ 0 ]) asNumber.
			last := payload at: #lastSeen ifAbsent: [ DateAndTime unixEpoch ].
			{ assoc key. credits. last } ])
			asSortedCollection: [ :a :b |
				(a second = b second)
					ifTrue: [ a third > b third ]
					ifFalse: [ a second > b second ] ].

	topN := ranked first: (self maxCount min: ranked size).

	topN do: [ :triple | | classNameSym |
		classNameSym := triple first asSymbol.
		"Completion for globals/classes uses NECGlobalEntry"
		aBlock value: (NECGlobalEntry contents: classNameSym node: astNode) ].
]

{ #category : 'accessing' }
CoTopCreditsClassFetcher >> maxCount [
	^ maxCount ifNil: [ maxCount := 2 ]
]

{ #category : 'accessing' }
CoTopCreditsClassFetcher >> maxCount: anObject [

	maxCount := anObject
]

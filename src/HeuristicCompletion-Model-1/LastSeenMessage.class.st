Class {
	#name : 'LastSeenMessage',
	#superclass : 'ClyBrowserToolMorph',
	#instVars : [
		'methodName'
	],
	#classVars : [
		'CurrentSelector',
		'CurrentStart',
		'LastSeen'
	],
	#category : 'HeuristicCompletion-Model-1',
	#package : 'HeuristicCompletion-Model-1'
}

{ #category : 'tracing' }
LastSeenMessage class >> allLastSeen [
    "Return a copy of the dictionary so callers don’t mutate internals."
    LastSeen ifNil: [ ^ Dictionary new ].
    ^ LastSeen copy.
]

{ #category : 'class initialization' }
LastSeenMessage class >> initialize [
    LastSeen := Dictionary new.
]

{ #category : 'tracing' }
LastSeenMessage class >> keys [
    LastSeen ifNil: [ ^ #() ].
    ^ LastSeen keys asArray sorted.
]

{ #category : 'tracing' }
LastSeenMessage class >> lastSeenAtKey: aString [
    "Return the stored payload (timestamp here) or nil."
    LastSeen ifNil: [ ^ nil ].
    ^ LastSeen at: aString ifAbsent: [ nil ].
]

{ #category : 'tracing' }
LastSeenMessage class >> packageActivation [ 

    <classAnnotation>
    ^ ClyTabActivationStrategyAnnotation for: Package asCalypsoItemContext
]

{ #category : 'tracing' }
LastSeenMessage class >> pruneOlderThan: aDateAndTime [
    "Optional: keep the dict tidy."
    LastSeen ifNil: [ ^ self ].
    LastSeen keysDo: [:k |
        ((LastSeen at: k) < aDateAndTime) ifTrue: [ LastSeen removeKey: k ifAbsent: [] ] ]
]

{ #category : 'tracing' }
LastSeenMessage class >> recordCompiledMethod: aCompiledMethod [
	"Record the last-seen method as a timestamp. Change payload if needed."

	| key now duration selector |
	LastSeen ifNil: [ LastSeen := Dictionary new ].

	    now := DateAndTime now.
    CurrentSelector ifNotNil: [
        duration := now - CurrentStart.
        LastSeen at: CurrentSelector
            ifPresent: [ :existing | LastSeen at: CurrentSelector put: existing + duration ]
            ifAbsent: [ LastSeen at: CurrentSelector put: duration ].
    ].

    selector := aCompiledMethod selector asString.
    CurrentSelector := selector.
    CurrentStart := now.
]

{ #category : 'tracing' }
LastSeenMessage class >> removeKey: aString [
    LastSeen ifNil: [ ^ self ].
    LastSeen removeKey: aString ifAbsent: [ ].
]

{ #category : 'tracing' }
LastSeenMessage class >> reset [

	<script>
	LastSeen := Dictionary new.
	    CurrentSelector := nil.
    CurrentStart := nil.
]

{ #category : 'testing' }
LastSeenMessage class >> shouldBeActivatedInContext: aBrowserContext [
	"aBrowserContext knows the current selection in the browser."
	aBrowserContext isMethodSelected ifTrue: [
			| cm |
			cm := aBrowserContext lastSelectedMethod.
			cm := (cm respondsTo: #compiledMethod)
				      ifTrue: [ cm compiledMethod ]
				      ifFalse: [ cm ].
			LastSeenMessage recordCompiledMethod: cm ].
	^ (super shouldBeActivatedInContext: aBrowserContext) and: [ aBrowserContext isMethodSelected ]
]

{ #category : 'building' }
LastSeenMessage >> build [
]

{ #category : 'building' }
LastSeenMessage >> methodName [

	^ methodName
]

{ #category : 'building' }
LastSeenMessage >> methodName: anObject [

	methodName := anObject
]

{ #category : 'building' }
LastSeenMessage >> setUpModelFromContext [

	methodName := context lastSelectedMethod selector.
]

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

{ #category : 'as yet unclassified' }
LastSeenMessage class >> allLastSeen [
    "Return a copy of the dictionary so callers don’t mutate internals."
    LastSeen ifNil: [ ^ Dictionary new ].
    ^ LastSeen copy.
]

{ #category : 'as yet unclassified' }
LastSeenMessage class >> initialize [
    LastSeen := Dictionary new.
]

{ #category : 'as yet unclassified' }
LastSeenMessage class >> keys [
    LastSeen ifNil: [ ^ #() ].
    ^ LastSeen keys asArray sorted.
]

{ #category : 'as yet unclassified' }
LastSeenMessage class >> lastSeenAtKey: aString [
    "Return the stored payload (timestamp here) or nil."
    LastSeen ifNil: [ ^ nil ].
    ^ LastSeen at: aString ifAbsent: [ nil ].
]

{ #category : 'as yet unclassified' }
LastSeenMessage class >> packageActivation [ 

    <classAnnotation>
    ^ ClyTabActivationStrategyAnnotation for: Package asCalypsoItemContext
]

{ #category : 'as yet unclassified' }
LastSeenMessage class >> pruneOlderThan: aDateAndTime [
    "Optional: keep the dict tidy."
    LastSeen ifNil: [ ^ self ].
    LastSeen keysDo: [:k |
        ((LastSeen at: k) < aDateAndTime) ifTrue: [ LastSeen removeKey: k ifAbsent: [] ] ]
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
LastSeenMessage class >> removeKey: aString [
    LastSeen ifNil: [ ^ self ].
    LastSeen removeKey: aString ifAbsent: [ ].
]

{ #category : 'as yet unclassified' }
LastSeenMessage class >> reset [

	<script>
	LastSeen := Dictionary new.
	    CurrentSelector := nil.
    CurrentStart := nil.
]

{ #category : 'as yet unclassified' }
LastSeenMessage class >> shouldBeActivatedInContext: aBrowserContext [
    "aBrowserContext knows the current selection in the browser."
    aBrowserContext isMethodSelected ifTrue: [
        | cm |
        cm := aBrowserContext lastSelectedMethod.
        "Handle Calypso/Nautilus wrappers or a plain CompiledMethod"
        cm := (cm respondsTo: #compiledMethod)
            ifTrue: [ cm compiledMethod ]
            ifFalse: [ cm ].

        "Record instead of printing"
        LastSeenMessage recordCompiledMethod: cm
    ].

    ^ (super shouldBeActivatedInContext: aBrowserContext)
        and: [ aBrowserContext isMethodSelected ]
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

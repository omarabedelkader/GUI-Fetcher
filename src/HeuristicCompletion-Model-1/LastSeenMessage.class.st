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
    ^ LastSeen collect: [ :each | each copy ].
]

{ #category : 'tracing' }
LastSeenMessage class >> creditsAtKey: aString [
    "Return accumulated credits or zero."
    | entry |
    LastSeen ifNil: [ ^ 0 ].
    entry := LastSeen at: aString ifAbsent: [ ^ 0 ].
    ^ entry at: #credits ifAbsent: [ 0 ].
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

	| entry |
	LastSeen ifNil: [ ^ nil ].
	entry := LastSeen at: aString ifAbsent: [ ^ nil ].
    ^ entry at: #duration ifAbsent: [ nil ].
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

	| now duration selector entry |
	LastSeen ifNil: [ LastSeen := Dictionary new ].

	now := DateAndTime now.
	CurrentSelector ifNotNil: [
			duration := now - CurrentStart.
			        entry := LastSeen at: CurrentSelector ifAbsent: [
            Dictionary new
                at: #duration put: Duration zero;
                at: #credits put: 0;
                at: #lastSeen put: CurrentStart;
                yourself ].
        entry at: #duration put: (entry at: #duration) + duration.
        entry at: #credits put: (entry at: #credits) + duration asSeconds.
        entry at: #lastSeen put: now.
        LastSeen at: CurrentSelector put: entry.
				
				
	].

	selector := aCompiledMethod selector asString.
	CurrentSelector := selector.
	CurrentStart := now
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

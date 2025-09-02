Class {
	#name : 'LastSeenClass',
	#superclass : 'ClyBrowserToolMorph',
	#instVars : [
		'className'
	],
	#classVars : [
		'CurrentClass',
		'CurrentStartClass',
		'LastSeenClass'
	],
	#category : 'HeuristicCompletion-Model-1',
	#package : 'HeuristicCompletion-Model-1'
}

{ #category : 'activation' }
LastSeenClass class >> allLastSeen [
    "Return a copy of the dictionary so callers don’t mutate internals."
    LastSeenClass ifNil: [ ^ Dictionary new ].
    ^ LastSeenClass collect: [ :each | each copy ].
]

{ #category : 'activation' }
LastSeenClass class >> creditsAtKey: aString [
    "Return accumulated credits or zero."
    | entry |
    LastSeenClass ifNil: [ ^ 0 ].
    entry := LastSeenClass at: aString ifAbsent: [ ^ 0 ].
    ^ entry at: #credits ifAbsent: [ 0 ].
]

{ #category : 'activation' }
LastSeenClass class >> initialize [
    LastSeenClass := Dictionary new.
]

{ #category : 'activation' }
LastSeenClass class >> keys [
    LastSeenClass ifNil: [ ^ #() ].
    ^ LastSeenClass keys asArray sorted.
]

{ #category : 'activation' }
LastSeenClass class >> lastSeenAtKey: aString [
	"Return the stored payload (timestamp here) or nil."

	| entry |
	LastSeenClass ifNil: [ ^ nil ].
	entry := LastSeenClass at: aString ifAbsent: [ ^ nil ].
    ^ entry at: #duration ifAbsent: [ nil ].
]

{ #category : 'activation' }
LastSeenClass class >> packageActivation [ 

    <classAnnotation>
    ^ ClyTabActivationStrategyAnnotation for: Package asCalypsoItemContext
]

{ #category : 'activation' }
LastSeenClass class >> pruneOlderThan: aDateAndTime [
    "Optional: keep the dict tidy."
    LastSeenClass ifNil: [ ^ self ].
    LastSeenClass keysDo: [:k |
        ((LastSeenClass at: k) < aDateAndTime) ifTrue: [ LastSeenClass removeKey: k ifAbsent: [] ] ]
]

{ #category : 'activation' }
LastSeenClass class >> recordClass: aClass [
    "Record the last-seen class as a timestamp. Change payload if needed."

    | now duration className entry |
    LastSeenClass ifNil: [ LastSeenClass := Dictionary new ].

    now := DateAndTime now.
    CurrentClass ifNotNil: [
        duration := now - CurrentStartClass.
        entry := LastSeenClass at: CurrentClass ifAbsent: [
            Dictionary new
                at: #duration put: Duration zero;
                at: #credits put: 0;
                at: #lastSeen put: CurrentStartClass;
                yourself ].
        entry at: #duration put: (entry at: #duration) + duration.
        entry at: #credits put: (entry at: #credits) + duration asSeconds.
        entry at: #lastSeen put: now.
        LastSeenClass at: CurrentClass put: entry.
    ].

    className := aClass name asString.
    CurrentClass := className.
    CurrentStartClass := now.

]

{ #category : 'activation' }
LastSeenClass class >> removeKey: aString [
    LastSeenClass ifNil: [ ^ self ].
    LastSeenClass removeKey: aString ifAbsent: [ ].
]

{ #category : 'class initialization' }
LastSeenClass class >> reset [

	<script>
	LastSeenClass := Dictionary new.
	    CurrentClass := nil.
    CurrentStartClass := nil.
]

{ #category : 'testing' }
LastSeenClass class >> shouldBeActivatedInContext: aBrowserContext [
        "aBrowserContext knows the current selection in the browser."
        aBrowserContext isClassSelected ifTrue: [
                        | cm |
                        cm := aBrowserContext lastSelectedClass.
                        LastSeenClass recordClass: cm ].
        ^ (super shouldBeActivatedInContext: aBrowserContext) and: [ aBrowserContext isClassSelected ]
]

{ #category : 'activation' }
LastSeenClass >> build [
]

{ #category : 'accessing' }
LastSeenClass >> className [

	^ className
]

{ #category : 'accessing' }
LastSeenClass >> className: anObject [

	className := anObject
]

{ #category : 'initialization' }
LastSeenClass >> setUpModelFromContext [

	className := context lastSelectedClass name.
]

Class {
	#name : 'LastSeenMessageTest',
	#superclass : 'TestCase',
	#category : 'HeuristicCompletion-Model-1-Selector',
	#package : 'HeuristicCompletion-Model-1',
	#tag : 'Selector'
}

{ #category : 'tests' }
LastSeenMessageTest >> helperMethod [
    ^ 42
]

{ #category : 'tests' }
LastSeenMessageTest >> helperMethod2 [
    ^ 43
]

{ #category : 'tests' }
LastSeenMessageTest >> testCreditsAtKeyUnknownIsZero [
    LastSeenMessage reset.
    self assert: (LastSeenMessage creditsAtKey: 'not-there') equals: 0.
]

{ #category : 'tests' }
LastSeenMessageTest >> testRecordCompiledMethodStoresEntry [
    | first second dict key entry |
    LastSeenMessage reset.
    first := self class >> #helperMethod.
    second := self class >> #helperMethod2.
    LastSeenMessage recordCompiledMethod: first.
    (Delay forMilliseconds: 10) wait.
    LastSeenMessage recordCompiledMethod: second.
    dict := LastSeenMessage allLastSeen.
    key := first selector asString.
    self assert: (dict includesKey: key).
    entry := dict at: key.
    self assert: (entry at: #credits) > 0.
    self assert: ((entry at: #lastSeen) isKindOf: DateAndTime).
]

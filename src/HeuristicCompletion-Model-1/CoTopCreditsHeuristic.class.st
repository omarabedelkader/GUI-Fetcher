Class {
	#name : 'CoTopCreditsHeuristic',
	#superclass : 'CoASTNodeFetcherHeuristic',
	#instVars : [
		'astNode',
		'maxCount'
	],
	#category : 'HeuristicCompletion-Model-1-Selector',
	#package : 'HeuristicCompletion-Model-1',
	#tag : 'Selector'
}

{ #category : 'requests' }
CoTopCreditsHeuristic >> appliesForNode: aNode inContext: aContext [
	^ aNode isMethod or: [ aNode isMessage ]
]

{ #category : 'requests' }
CoTopCreditsHeuristic >> buildFetcherFor: aNode inContext: aContext [
	^ CoTopCreditsSelectorFetcher new
		astNode: aNode;
		yourself
]

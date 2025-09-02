Class {
	#name : 'CoTopCreditsHeuristic',
	#superclass : 'CoASTNodeFetcherHeuristic',
	#instVars : [
		'astNode',
		'maxCount'
	],
	#category : 'HeuristicCompletion-Model-1',
	#package : 'HeuristicCompletion-Model-1'
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

Class {
	#name : 'CoTopCreditsClassHeuristic',
	#superclass : 'CoASTNodeFetcherHeuristic',
	#category : 'HeuristicCompletion-Model-1-Class',
	#package : 'HeuristicCompletion-Model-1',
	#tag : 'Class'
}

{ #category : 'requests' }
CoTopCreditsClassHeuristic >> appliesForNode: aNode inContext: aContext [
	"Offer when completing a variable/global name slot"
	^ aNode isVariable
]

{ #category : 'requests' }
CoTopCreditsClassHeuristic >> buildFetcherFor: aNode inContext: aContext [
	^ CoTopCreditsClassFetcher new
		astNode: aNode;
		yourself
]

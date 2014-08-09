class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer, @winState='') ->

  getScore: ->
    @scores()[0]

  isScoreSoft: ->
    # scores are calculated as an Ace equaling 1 but blackjack can have an Ace equal 11. If there is an Ace then the score is soft.
    @scores.length is 2

  hit: ->
    @add(@deck.pop()).last()
    if @getScore() > 21
      @winState = "Bust"
      @trigger "bust", @

  stand: ->
    @trigger "stand", @

  wins: ->
    @winState = "Winner"
    @trigger "wins", @

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]

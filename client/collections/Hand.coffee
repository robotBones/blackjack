class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer, @status) ->

  getScore: ->
    if @scores()[1]? and @scores()[1] <= 21 then @scores()[1] else @scores()[0]

  hasSoftScore: ->
    # scores are calculated as an Ace equaling 1 but blackjack can have an Ace equal 11. If there is an Ace then the score is soft.
    @getScore() is @scores()[1]

  isBust: ->
    score = @getScore()
    true if score > 21

  is21: ->
    score = @getScore()
    true if score is 21

  isBlackJack: ->
    @is21() and @.length is 2

  evalScore: ->
    @trigger "bust", @ if @isBust()

    if @isBlackJack()
      @trigger "blackjack", @

    else if @is21()
      @trigger "21", @

  hit: ->
    @add(@deck.pop()).last()
    console.log (if @isDealer then "dealer" else "player"), "hits!  Score is a #{if @hasSoftScore() then 'soft' else 'hard'} #{@getScore()}"
    @evalScore()

  stand: ->
    @trigger "stand", @

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

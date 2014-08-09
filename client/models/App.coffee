#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  # initialization of the game. deck.dealPlayer() produces hand collections.
  initialize: ->
    # App model wraps all other models as properties.
    # as properties they have to be accesed via setters/getters
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'discardPile', new Hand()

    # listening to hand collections
    #
    # end game instigator 1 of 4
    # listens whether deck is empty
    # if so then end game
    @get('deck').on 'remove', (hand)=>
      if @get('deck').length is 0
        console.log "deck is empty"
        @endGame(hand, 'emptyDeck')

    # end game instigator 2 of 4
    # when player stands the turn goes to dealer
    # when dealer stands that ends the game
    @get('playerHand').on 'stand', (hand)=>
      console.log "player stands"
      @dealerStartTurn()
    @get('dealerHand').on 'stand', (hand)=>
      console.log "dealer stands"
      @endGame(hand, 'dealerStands')

    # end game instigator 3 of 4
    # when a hand's score is over 21 it busts
    @get('playerHand').on 'bust', (player)=>
      console.log "App heard the player busted"
      @endGame(player, 'bust')
    @get('dealerHand').on 'bust', (dealer)=>
      console.log "App heard the dealer busted"
      @endGame(dealer, 'bust')

    # end game instigator 4 of 4
    # someone gets a black jack (10, Ace) or score of 21
    @get('playerHand').on 'blackjack', (player)=>
      console.log "App heard the player blackjacked"
      @endGame(player, 'blackjack')
    @get('dealerHand').on 'blackjack', (dealer)=>
      console.log "App heard the dealer blackjacked"
      @endGame(dealer, 'blackjack')

    @get('playerHand').on '21', (player)=>
      console.log "App heard the player scored 21"
      @endGame(player, '21')
    @get('dealerHand').on '21', (dealer)=>
      console.log "App heard the dealer scored 21"
      @endGame(dealer, '21')

    # lastly, check for a player's blackjack upon initialization
    @get('playerHand').evalScore()


  ################## end of initialize ###################

  # game logic
  endGame: (hand, endEvent)->
    # tell appView to toggle UI buttons
    @trigger "noControl", @

    # empty deck
    deck = @get "deck"
    discardPile = @get "discardPile"

    if endEvent is "emptyDeck"
      console.log "ending round and reshuffling deck"
      while discardPile.length != 0
        deck.add discardPile.pop()
      deck.reset(deck.shuffle(), {silent:true});
    # player busts
    # player wins with #
    # player blackjacks
    # dealer wins with tie
    @checkWinner()

    console.log "--------------------------------------"
    console.log ""
    console.log "--------------------------------------"

  ################## end of endGame #####################

  checkWinner: (hand, endEvent)->
    player = @get 'playerHand'
    dealer = @get 'dealerHand'

    result =
      winner: null
      loser: null

    # player loses on a tie
    if player.getScore() is dealer.getScore()
      result.winner = dealer
      result.loser = player
      console.log("tie, player loses")

    #
    else
      switch endEvent
        when "bust" then console.log("bust")
        when "blackjack" then console.log("blackjack")
        when "21" then console.log("21");
        when "dealerStands" then console.log("dealer stands")


  ################## end of checkWinner #####################

  nextRound: ->
    deck = @get('deck')
    player = @get('playerHand')
    dealer = @get('dealerHand')
    discardPile = @get('discardPile')

    # cleaning the board and caching card models in a discardPile hand collection
    while player.length > 0
      discardPile.add(player.pop())

    while dealer.length > 0
      discardPile.add(dealer.pop())

    # dealing cards from the deck collection
    player.add(deck.pop())
    player.add(deck.pop())

    dealer.add(deck.pop().flip())
    dealer.add(deck.pop())

    # reinstating the play buttons
    @trigger "control", @


  dealerStartTurn: ->
    console.log "dealers starts turn"
    @trigger "noControl", @

    dealer = @get('dealerHand')

    # dealer reveals hidden card
    dealer.at(0).flip()

    while dealer.getScore() < 17
      dealer.hit() # dealer hits until condition instigates end game

    #dealer hits on soft 17
    while dealer.hasSoftScore() and dealer.getScore() is 17
      dealer.hit

    # any hard score 17 and above that doesn't bust or reach 21 calls of a stand()
    if dealer.getScore() <= 21 and dealer.getScore() > 17
      dealer.stand()
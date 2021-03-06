// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Hand = (function(_super) {
    __extends(Hand, _super);

    function Hand() {
      return Hand.__super__.constructor.apply(this, arguments);
    }

    Hand.prototype.model = Card;

    Hand.prototype.initialize = function(array, deck, isDealer, winState) {
      this.deck = deck;
      this.isDealer = isDealer;
      this.winState = winState != null ? winState : '';
    };

    Hand.prototype.getScore = function() {
      return this.scores()[0];
    };

    Hand.prototype.isScoreSoft = function() {
      return this.scores.length === 2;
    };

    Hand.prototype.hit = function() {
      console.log(this.deck.last().attributes);
      this.add(this.deck.pop()).last();
      console.log(this.deck.last(), this.last().attributes);
      if (this.getScore() > 21) {
        this.winState = "Bust";
        return this.trigger("bust", this);
      }
    };

    Hand.prototype.stand = function() {
      return this.trigger("stand", this);
    };

    Hand.prototype.wins = function() {
      this.winState = "Winner";
      return this.trigger("wins", this);
    };

    Hand.prototype.scores = function() {
      var hasAce, score;
      hasAce = this.reduce(function(memo, card) {
        return memo || card.get('value') === 1;
      }, false);
      score = this.reduce(function(score, card) {
        return score + (card.get('revealed') ? card.get('value') : 0);
      }, 0);
      if (hasAce) {
        return [score, score + 10];
      } else {
        return [score];
      }
    };

    return Hand;

  })(Backbone.Collection);

}).call(this);

//# sourceMappingURL=Hand.map

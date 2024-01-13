import 'package:flutter/material.dart';
import 'package:solitaire/playing_card.dart';
import 'package:solitaire/transformed_card.dart';

typedef CardAcceptCallback = Null Function(List<PlayingCard> card, int fromIndex);

// This is a stack of overlayed cards (implemented using a stack)
class CardColumn extends StatefulWidget {
  // List of cards in the stack
  final List<PlayingCard> cards;

  // Callback when card is added to the stack
  final CardAcceptCallback onCardsAdded;

  // The index of the list in the game
  final int columnIndex;

  const CardColumn(
      {super.key, required this.cards,
      required this.onCardsAdded,
      required this.columnIndex});

  @override
  _CardColumnState createState() => _CardColumnState();
}

class _CardColumnState extends State<CardColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.topCenter,
      height: 30.0 * 17.0,
      width: 100.0,
      margin: const EdgeInsets.all(1.0),
      child: DragTarget<Map>(
        builder: (context, listOne, listTwo) {
          return Stack(
            children: widget.cards.map((card) {
              int index = widget.cards.indexOf(card);
              return TransformedCard(
                playingCard: card,
                transformIndex: index,
                attachedCards: widget.cards.sublist(index, widget.cards.length),
                columnIndex: widget.columnIndex,
              );
            }).toList(),
          );
        },
        onWillAccept: (value) {
          // If empty, accept
          if (widget.cards.isEmpty) {
            return true;
          }

          // Get dragged cards list
          List<PlayingCard> draggedCards = value?["cards"];
          PlayingCard firstCard = draggedCards.first;
          if (firstCard.cardColor == CardColor.red) {
            if (widget.cards.last.cardColor == CardColor.red) {
              return false;
            }

            int lastColumnCardIndex =
                CardType.values.indexOf(widget.cards.last.cardType);
            int firstDraggedCardIndex =
                CardType.values.indexOf(firstCard.cardType);

            if (lastColumnCardIndex != firstDraggedCardIndex + 1) {
              return false;
            }
          } else {
            if (widget.cards.last.cardColor == CardColor.black) {
              return false;
            }

            int lastColumnCardIndex =
                CardType.values.indexOf(widget.cards.last.cardType);
            int firstDraggedCardIndex =
                CardType.values.indexOf(firstCard.cardType);

            if (lastColumnCardIndex != firstDraggedCardIndex + 1) {
              return false;
            }
          }
          return true;
        },
        onAccept: (value) {
          widget.onCardsAdded(
            value["cards"],
            value["fromIndex"],
          );
        },
      ),
    );
  }
}

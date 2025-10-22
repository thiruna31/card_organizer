import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/folder.dart';
import '../models/card.dart';
import '../repos/card_repo.dart';

class CardsScreen extends StatefulWidget {
  final Folder folder;
  CardsScreen({required this.folder});
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  late Future<List<CardModel>> _futureCards;

  @override
  void initState() {
    super.initState();
    _refreshCards();
  }

  void _refreshCards() {
    _futureCards = CardRepo().getCardsByFolder(widget.folder.id!);
  }

  Future<void> _addCard() async {
    List<CardModel> cards = await CardRepo().getCardsByFolder(widget.folder.id!);
    if (cards.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum 6 cards only'))
      );
      return;
    }
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    String imgPath = picked?.path ?? '';
    String newCardValue = 'Card ${cards.length + 1}';
    await CardRepo().insertCard(CardModel(
        folderId: widget.folder.id!,
        value: newCardValue,
        imageUrl: imgPath
    ));
    setState(() => _refreshCards());
  }

  Future<void> _deleteCard(CardModel card) async {
    List<CardModel> cards = await CardRepo().getCardsByFolder(widget.folder.id!);
    if (cards.length <= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Minimum 3 cards required'))
      );
      return;
    }
    await CardRepo().deleteCard(card.id!);
    setState(() => _refreshCards());
  }

  Widget _buildCardImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Icon(Icons.image, size: 60);
    }
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 80,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 60),
      );
    } else {
      return Image.file(
        File(imageUrl),
        width: 80,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 60),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.folder.name} Cards')),
      body: FutureBuilder<List<CardModel>>(
        future: _futureCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards in this folder.'));
          }
          final cards = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) => Card(
              elevation: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCardImage(cards[index].imageUrl),
                  SizedBox(height: 8),
                  Text(cards[index].value, textAlign: TextAlign.center),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteCard(cards[index]),
                  ),
                ],
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCard,
        child: Icon(Icons.add),
      ),
    );
  }
}

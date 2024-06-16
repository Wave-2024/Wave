import 'package:wave/models/chat_model.dart';
import 'package:wave/models/message_model.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/utils/constants/database_endpoints.dart';

class ChatData {
  ///   The `checkIfChatExists` function returns a `Future<bool>`. The function performs two queries to
  /// check if a chat exists between two users based on the provided `firstUser` and `secondUser`. It
  /// checks if there is a document in the database where either `firstUser` is paired with `secondUser`
  /// or `secondUser` is paired with `firstUser`. If any of
  static Future<CustomResponse> checkIfChatExists(
      String firstUser, String secondUser) async {
    try {
      // Perform the first query to check if firstUser is firstUser and secondUser is secondUser
      final querySnapshot1 = await Database.chatDatabase
          .where('firstUser', isEqualTo: firstUser)
          .where('secondUser', isEqualTo: secondUser)
          .limit(1)
          .get();

      // Perform the second query to check if firstUser is secondUser and secondUser is firstUser
      final querySnapshot2 = await Database.chatDatabase
          .where('firstUser', isEqualTo: secondUser)
          .where('secondUser', isEqualTo: firstUser)
          .limit(1)
          .get();

      // Check if any of the two queries returned a document
      if (querySnapshot1.docs.isNotEmpty || querySnapshot2.docs.isNotEmpty) {
        String chatId = querySnapshot1.docs.isNotEmpty
            ? querySnapshot1.docs.first.id
            : querySnapshot2.docs.first.id;
        return CustomResponse(responseStatus: true, response: chatId);
      }

      return CustomResponse(responseStatus: false);
    } catch (e) {
      print('Error checking if chat exists: $e');
      return CustomResponse(responseStatus: false);
    }
  }

  static Future<CustomResponse> createChat(
      String firstUser, String secondUser) async {
    try {
      Chat chat = Chat(
          id: 'id',
          firstUser: firstUser,
          secondUser: secondUser,
          lastMessage: "Say Hi to your friend !",
          timeOfLastMessage: DateTime.now());

      /// The line `var chatCreationResponse = await Database.chatDatabase.add(chat.toMap());` is creating a
      /// new chat document in the database using the `add` method provided by the `chatDatabase` instance.
      var chatCreationResponse = await Database.chatDatabase.add(chat.toMap());

      /// The line `await Database.chatDatabase.doc(chatCreationResponse.id).update({'id':
      /// chatCreationResponse.id});` is updating the 'id' field of the chat document in the database
      /// with the newly generated ID from the chat creation response. This ensures that the chat
      /// document has a unique identifier associated with it for future reference and retrieval.
      await Database.chatDatabase
          .doc(chatCreationResponse.id)
          .update({'id': chatCreationResponse.id});

      chat = chat.copyWith(id: chatCreationResponse.id);

      /// `await Database.getUserChats(firstUser).doc(chatCreationResponse.id).set({'id':
      /// chatCreationResponse.id});` is updating the user's chat list in the database with the newly
      /// created chat's ID.

      await Database.getUserChats(firstUser).doc(chat.id).set(chat.toMap());

      /// This line of code is updating the user's chat list in the database with the newly created
      /// chat's ID for the `secondUser`. It is using the `getUserChats` method from the `Database` class
      /// to access the document corresponding to the `secondUser` and then setting a new field with the
      /// key `'id'` and the value of `chatCreationResponse.id`. This ensures that the `secondUser` has a
      /// reference to the newly created chat in their chat list for future retrieval and management.
      await Database.getUserChats(secondUser).doc(chat.id).set(chat.toMap());

      return CustomResponse(
          responseStatus: true, response: chatCreationResponse.id);
    } catch (e) {
      print('Error creating chat: $e');
      return CustomResponse(
          responseStatus: false, response: 'Failed to create chat.');
    }
  }

  static Future<CustomResponse> sendMessage(
      Message message, String firstUser, String secondUser) async {
    try {
      // Add the message to the 'messages' subcollection of the appropriate chat document
      var messageResponse = await Database.chatDatabase
          .doc(message.chatId)
          .collection('messages')
          .add(message.toMap());
      // Update the message id
      Database.chatDatabase
          .doc(message.chatId)
          .collection('messages')
          .doc(messageResponse.id)
          .update({'id': messageResponse.id});

      // Update the lastMessage and timeOfLastMessage fields in the chat document
      Database.chatDatabase.doc(message.chatId).update({
        'lastMessage': message.message,
        'timeOfLastMessage': message.createdAt.millisecondsSinceEpoch,
      });

      // Update the latest message for both the users

      Database.userDatabase
          .doc(firstUser)
          .collection('chats')
          .doc(message.chatId)
          .update({
        'lastMessage': message.message,
        'timeOfLastMessage': message.createdAt.millisecondsSinceEpoch,
      });

      Database.userDatabase
          .doc(secondUser)
          .collection('chats')
          .doc(message.chatId)
          .update({
        'lastMessage': message.message,
        'timeOfLastMessage': message.createdAt.millisecondsSinceEpoch,
      });

      return CustomResponse(
          responseStatus: true, response: 'Message sent successfully.');
    } catch (e) {
      print('Error sending message: $e');
      return CustomResponse(
          responseStatus: false, response: 'Failed to send message.');
    }
  }

  static Future<CustomResponse> unsendMessage(
      Message message, String firstUser, String secondUser) async {
    try {
      // Remove the message from 'messages' subcollection of the appropriate chat document
      await Database.chatDatabase
          .doc(message.chatId)
          .collection('messages')
          .doc(message.id)
          .delete();

      var lastChatDetail =
          await Database.chatDatabase.doc(message.chatId).get();
      Chat chat = Chat.fromMap(lastChatDetail.data()!);

      // Update the lastMessage and timeOfLastMessage fields in the chat document only if deleted message was the last message
      if (chat.timeOfLastMessage == message.createdAt) {
        Database.chatDatabase.doc(message.chatId).update({
          'lastMessage': 'Last message was deleted',
        });
      }

      // Update the latest message for both the users only if deleted message was the last message
      if (chat.timeOfLastMessage == message.createdAt) {
        Database.userDatabase
            .doc(firstUser)
            .collection('chats')
            .doc(message.chatId)
            .update({
          'lastMessage': message.message,
        });

        Database.userDatabase
            .doc(secondUser)
            .collection('chats')
            .doc(message.chatId)
            .update({
          'lastMessage': message.message,
        });
      }

      return CustomResponse(
          responseStatus: true, response: 'Message deleted successfully.');
    } catch (e) {
      print('Error deleting message: $e');
      return CustomResponse(
          responseStatus: false, response: 'Failed to deleted message.');
    }
  }
}

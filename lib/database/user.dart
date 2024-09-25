import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/models/message.dart';
import 'package:dompet/models/order.dart';
import 'package:dompet/models/card.dart';

class UserDatabaser {
  static Database? db;
  static get isCreated => db.bv;

  // init
  static Future<void> close() async {
    await db?.close();
    UserDatabaser.db = null;
  }

  static Future<void> create(Database? db) async {
    if (db.bv) {
      UserDatabaser.db = db!;

      await db.execute(
        '''
        CREATE TABLE UserCard (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          card_no TEXT NOT NULL,
          balance REAL NOT NULL DEFAULT '206500.00',
          card_type TEXT NOT NULL,
          bank_name TEXT NOT NULL,
          expiry_date TEXT NOT NULL,
          status TEXT NOT NULL
        )
        ''',
      );

      await db.execute(
        '''
        CREATE TABLE UserOrder (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          icon TEXT NOT NULL,
          name TEXT NOT NULL,
          type TEXT NOT NULL,
          date TEXT NOT NULL,
          money REAL NOT NULL
        )
        ''',
      );

      await db.execute(
        '''
        CREATE TABLE UserMessage (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL,
          desc TEXT NOT NULL,
          date TEXT NOT NULL,
          money REAL NOT NULL,
          is_read TEXT NOT NULL DEFAULT 'N'
        )
        ''',
      );

      // 预设数据
      final year = DateTime.now().year;
      const format = 'yyyy-MM-dd HH:mm:ss';
      final formatter = DateFormat(format);

      await UserDatabaser.createUserCard(
        Card(
          cardNo: '621062xxxxxx8888',
          cardType: 'Debit Card',
          bankName: 'Citibank',
          expiryDate: '2058-12-01',
          balance: 206500.00,
          status: 'Y',
        ),
      );

      await UserDatabaser.createUserOrder([
        // year-0
        Order(
          icon: 'emma',
          name: 'Emma',
          type: 'Transfer',
          date: formatter.format(DateTime(year, 6, 17, 11, 11)),
          money: 10000.0,
        ),
        Order(
          icon: 'me',
          name: 'Me',
          type: 'Top up',
          date: formatter.format(DateTime(year, 9, 2, 17, 3)),
          money: 50000.0,
        ),
        Order(
          icon: 'netflix',
          name: 'Netflix',
          type: 'Payment',
          date: formatter.format(DateTime(year, 9, 11, 13, 7)),
          money: -2000.0,
        ),
        Order(
          icon: 'paypal',
          name: 'PayPal',
          type: 'Transfer',
          date: formatter.format(DateTime(year, 9, 21, 8, 8)),
          money: -1500.0,
        ),

        // year-1
        Order(
          icon: 'emma',
          name: 'Emma',
          type: 'Payment',
          date: formatter.format(DateTime(year - 1, 3, 8, 8, 11)),
          money: -20000.0,
        ),
        Order(
          icon: 'paypal',
          name: 'PayPal',
          type: 'Payment',
          date: formatter.format(DateTime(year - 1, 4, 7, 15, 14)),
          money: -15000.0,
        ),
        Order(
          icon: 'me',
          name: 'Me',
          type: 'Top up',
          date: formatter.format(DateTime(year - 1, 6, 6, 17, 19)),
          money: 20000.0,
        ),
        Order(
          icon: 'david',
          name: 'David',
          type: 'Transfer',
          date: formatter.format(DateTime(year - 1, 8, 8, 20, 21)),
          money: -40000.0,
        ),

        // year-2
        Order(
          icon: 'netflix',
          name: 'Netflix',
          type: 'Payment',
          date: formatter.format(DateTime(year - 2, 5, 30, 14, 25)),
          money: -3000.0,
        ),
        Order(
          icon: 'emma',
          name: 'Emma',
          type: 'Top up',
          date: formatter.format(DateTime(year - 2, 7, 11, 9, 1)),
          money: 55000.0,
        ),
        Order(
          icon: 'paypal',
          name: 'PayPal',
          type: 'Payment',
          date: formatter.format(DateTime(year - 2, 7, 19, 13, 7)),
          money: -700.0,
        ),
        Order(
          icon: 'david',
          name: 'David',
          type: 'Transfer',
          date: formatter.format(DateTime(year - 2, 9, 3, 9, 57)),
          money: 27000.0,
        ),

        // year-3
        Order(
          icon: 'emma',
          name: 'Emma',
          type: 'Transfer',
          date: formatter.format(DateTime(year - 3, 6, 1, 9, 37)),
          money: -40000.0,
        ),
        Order(
          icon: 'paypal',
          name: 'PayPal',
          type: 'Payment',
          date: formatter.format(DateTime(year - 3, 6, 20, 11, 11)),
          money: -5000.0,
        ),
        Order(
          icon: 'me',
          name: 'Me',
          type: 'Top up',
          date: formatter.format(DateTime(year - 3, 9, 9, 19, 17)),
          money: 3000.0,
        ),
        Order(
          icon: 'david',
          name: 'David',
          type: 'Transfer',
          date: formatter.format(DateTime(year - 3, 10, 17, 15, 11)),
          money: 2500.0,
        ),

        // year-4
        Order(
          icon: 'me',
          name: 'Me',
          type: 'Top up',
          date: formatter.format(DateTime(year - 4, 9, 21, 5, 10)),
          money: 200000.0,
        ),
        Order(
          icon: 'netflix',
          name: 'Netflix',
          type: 'Payment',
          date: formatter.format(DateTime(year - 4, 10, 9, 17, 12)),
          money: -1800.0,
        ),
        Order(
          icon: 'paypal',
          name: 'PayPal',
          type: 'Transfer',
          date: formatter.format(DateTime(year - 4, 11, 1, 8, 36)),
          money: -12000.0,
        ),
        Order(
          icon: 'david',
          name: 'David',
          type: 'Transfer',
          date: formatter.format(DateTime(year - 4, 12, 22, 15, 22)),
          money: -20000.0,
        ),
      ]);

      await UserDatabaser.createUserMessage([
        // year-0
        Message(
          type: 'Transfer',
          desc: 'You received a transfer from Emma',
          date: formatter.format(DateTime(year, 6, 17, 11, 11)),
          money: 10000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Top up',
          desc: 'You top-up some money',
          date: formatter.format(DateTime(year, 9, 2, 17, 3)),
          money: 50000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Payment',
          desc: 'You paid money to top up Netflix',
          date: formatter.format(DateTime(year, 9, 11, 13, 7)),
          money: -2000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Transfer',
          desc: 'You transferred money to PayPal',
          date: formatter.format(DateTime(year, 9, 21, 8, 8)),
          money: -1500.0,
          isRead: 'Y',
        ),

        // year-1
        Message(
          type: 'Payment',
          desc: 'You paid money to Emma',
          date: formatter.format(DateTime(year - 1, 3, 8, 8, 11)),
          money: -20000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Payment',
          desc: 'You paid money to PayPal',
          date: formatter.format(DateTime(year - 1, 4, 7, 15, 14)),
          money: -15000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Top up',
          desc: 'You top-up some money',
          date: formatter.format(DateTime(year - 1, 6, 6, 17, 19)),
          money: 20000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Transfer',
          desc: 'You transfer money to David',
          date: formatter.format(DateTime(year - 1, 8, 8, 20, 21)),
          money: -40000.0,
          isRead: 'Y',
        ),

        // year-2
        Message(
          type: 'Payment',
          desc: 'You paid money to Netflix',
          date: formatter.format(DateTime(year - 2, 5, 30, 14, 25)),
          money: -3000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Top up',
          desc: 'You received a top-up from Emma',
          date: formatter.format(DateTime(year - 2, 7, 11, 9, 1)),
          money: 55000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Payment',
          desc: 'You paid money to PayPal',
          date: formatter.format(DateTime(year - 2, 7, 19, 13, 7)),
          money: -700.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Transfer',
          desc: 'You received a transfer from David',
          date: formatter.format(DateTime(year - 2, 9, 3, 9, 57)),
          money: 27000.0,
          isRead: 'Y',
        ),

        // year-3
        Message(
          type: 'Transfer',
          desc: 'You transfer money to Emma',
          date: formatter.format(DateTime(year - 3, 6, 1, 9, 37)),
          money: -40000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Payment',
          desc: 'You paid money to PayPal',
          date: formatter.format(DateTime(year - 3, 6, 20, 11, 11)),
          money: -5000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Top up',
          desc: 'You top-up some money',
          date: formatter.format(DateTime(year - 3, 9, 9, 19, 17)),
          money: 3000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Transfer',
          desc: 'You received a transfer from David',
          date: formatter.format(DateTime(year - 3, 10, 17, 15, 11)),
          money: 2500.0,
          isRead: 'Y',
        ),

        // year-4
        Message(
          type: 'Top up',
          desc: 'You top-up some money',
          date: formatter.format(DateTime(year - 4, 9, 21, 5, 10)),
          money: 200000.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Payment',
          desc: 'You paid money to Netflix',
          date: formatter.format(DateTime(year - 4, 10, 9, 17, 12)),
          money: -1800.0,
          isRead: 'Y',
        ),
        Message(
          type: 'Transfer',
          desc: 'You transferred money to PayPal',
          date: formatter.format(DateTime(year - 4, 11, 1, 8, 36)),
          money: -12000.0,
        ),
        Message(
          type: 'Transfer',
          desc: 'You transferred money to David',
          date: formatter.format(DateTime(year - 4, 12, 22, 15, 22)),
          money: -166200.0,
        ),
      ]);
    }
  }

  // UserCard
  static Future<Card?> createUserCard(Card card) async {
    return db!.transaction<Card?>((txn) async {
      await txn.rawInsert(
        'insert into UserCard(card_no, balance, card_type, bank_name, expiry_date, status) VALUES(?, ?, ?, ?, ?, ?)',
        [
          card.cardNo,
          card.balance,
          card.cardType,
          card.bankName,
          card.expiryDate,
          card.status,
        ],
      );

      return card;
    });
  }

  static Future<Card?> updateUserCard(Card card) async {
    const format = 'yyyy-MM-dd HH:mm:ss';
    final formatter = DateFormat(format);

    return db!.transaction<Card?>((txn) async {
      final result = await txn.rawQuery(
        'select count(*) from UserCard where id == "${card.id}"',
      );

      if (result.isNotEmpty) {
        await txn.rawUpdate(
          'update UserCard set card_no = ?, balance = ?, card_type = ?, bank_name = ?, expiry_date = ?, status = ? where id == ?',
          [
            card.cardNo,
            card.balance,
            card.cardType,
            card.bankName,
            formatter.format(DateTime.now()),
            card.status,
            card.id,
          ],
        );

        return card;
      }

      return null;
    });
  }

  static Future<Card?> queryUserCard() async {
    return db?.transaction<Card?>((txn) async {
      final result = await txn.rawQuery(
        '''
        select 
          id,
          card_no,
          balance,
          card_type,
          bank_name,
          expiry_date,
          status
        from UserCard
        order by datetime(expiry_date) desc
        ''',
      );

      if (result.isNotEmpty) {
        return Card.from(result[0]);
      }

      return null;
    });
  }

  // UserOrder
  static Future<List<Order>> createUserOrder(Object orders) async {
    if (orders is Order) {
      orders = [orders];
    }

    if (orders is List<Order>) {
      final list = orders;

      const format = 'yyyy-MM-dd HH:mm:ss';
      final formatter = DateFormat(format);

      return db!.transaction<List<Order>>((txn) async {
        for (var item in list) {
          await txn.rawInsert(
            'insert into UserOrder(icon, name, type, date, money) VALUES(?, ?, ?, ?, ?)',
            [
              item.icon,
              item.name,
              item.type,
              item.date.isEmpty ? formatter.format(DateTime.now()) : item.date,
              item.money,
            ],
          );
        }

        return list;
      });
    }

    return [];
  }

  static Future<List<Order>> queryUserOrders() async {
    final list = await db?.transaction<List<Order>>((txn) async {
      final result = await txn.rawQuery(
        '''
        select 
          id,
          icon,
          name,
          type,
          date,
          money
        from UserOrder
        order by datetime(date) desc
        ''',
      );

      return result.map((card) => Order.from(card)).toList();
    });

    return list ?? [];
  }

  // UserMessage
  static Future<List<Message>> createUserMessage(Object messages) async {
    if (messages is Message) {
      messages = [messages];
    }

    if (messages is List<Message>) {
      final list = messages;

      const format = 'yyyy-MM-dd HH:mm:ss';
      final formatter = DateFormat(format);

      return db!.transaction<List<Message>>((txn) async {
        for (var item in list) {
          await txn.rawInsert(
            'insert into UserMessage(type, desc, date, money, is_read) VALUES(?, ?, ?, ?, ?)',
            [
              item.type,
              item.desc,
              item.date.isEmpty ? formatter.format(DateTime.now()) : item.date,
              item.money,
              item.isRead.isNotEmpty ? item.isRead : null,
            ],
          );
        }

        return list;
      });
    }

    return [];
  }

  static Future<List<Message>> readUserMessage(Message message) async {
    return db!.transaction<List<Message>>((txn) async {
      await txn.rawUpdate(
        'update UserMessage set is_read = ? where id == ?',
        [
          message.isRead.isNotEmpty ? message.isRead : 'N',
          message.id,
        ],
      );

      final result = await txn.rawQuery(
        '''
        select 
          id,
          type,
          desc,
          date,
          money,
          is_read
        from UserMessage
        order by datetime(date) desc
        ''',
      );

      return result.map((card) => Message.from(card)).toList();
    });
  }

  static Future<List<Message>> queryUserMessages() async {
    final list = await db?.transaction<List<Message>>((txn) async {
      final result = await txn.rawQuery(
        '''
        select 
          id,
          type,
          desc,
          date,
          money,
          is_read
        from UserMessage
        order by datetime(date) desc
        ''',
      );

      return result.map((card) => Message.from(card)).toList();
    });

    return list ?? [];
  }
}

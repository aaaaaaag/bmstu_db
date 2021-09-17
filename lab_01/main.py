import psycopg2
from faker import Faker
from psycopg2 import Error
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from random import randint
from random import getrandbits

fake = Faker()
sex_types = ['male', 'female']
country_types = ['Russia', 'USA', 'China', 'Germany']
random_words = ['inspector',
'epicalyx',
'basic',
'community',
'functional',
'measure',
'eat',
'variable',
'fax',
'liberty',
'arrangement',
'pat',
'brick',
'mean',
'scatter',
'enfix',
'tablet',
'boat',
'agree',
'chew',
'stuff',
'prosecution',
'brake',
'waiter',
'embarrassment',
'reproduce',
'film',
'long',
'eagle', 'forest', 'blue', 'cloud', 'sky', 'wood', 'falcon']


type_words = ['TV', 'Microwave', 'Computer', 'Chair', 'Table', 'Lamp', 'Pot', 'Hat', 'TShirt', 'Window', 'Phone', 'Socks', 'Trash', 'Pen', 'Bottle', 'List', 'Pants', 'Boots']
color_type = ['Red', 'Green', 'Blue', 'Yellow', 'Black', 'White']
try:
    # Подключение к существующей базе данных
    connection = psycopg2.connect(user="postgres",
                                  # пароль, который указали при установке PostgreSQL
                                  password="password",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="thingbuyer")

    # Курсор для выполнения операций с базой данных
    cursor = connection.cursor()
    # Распечатать сведения о PostgreSQL
    print("Информация о сервере PostgreSQL")
    print(connection.get_dsn_parameters(), "\n")
    # Выполнение SQL-запроса

    for i in range(1000):
        name = fake.name()
        names = name.split(' ')
        firstName = names[0]
        secondName = names[1]
        cursor.execute("INSERT INTO buyers(first_name, second_name, sex, country, age) VALUES('{0}', '{1}', '{2}', '{3}', {4});".format(firstName, secondName, sex_types[randint(0, 1)], country_types[randint(0, 3)], randint(1, 5)))
        connection.commit()

    for i in range(1000):
        name = fake.name()
        names = name.split(' ')
        firstName = names[0]
        secondName = names[1]
        cursor.execute("INSERT INTO sellers(first_name, second_name, sex, rating, country) VALUES('{0}', '{1}', '{2}', '{3}', '{4}');".format(firstName, secondName, sex_types[randint(0, 1)], str(randint(1, 5)), country_types[randint(0, 3)]))
        connection.commit()

    for i in range(1000):
        word1 = random_words[randint(0, 34)]
        word2 = random_words[randint(0, 34)]
        typeWord = type_words[randint(0, 17)]
        resultName = word1 + " " + word2 + " " + typeWord;
        name = fake.name()
        names = name.split(' ')
        firstName = names[0]
        secondName = names[1]
        print(resultName)
        cursor.execute("INSERT INTO items(name, weight, price, color, guarantee_years) VALUES('{0}', '{1}', '{2}', '{3}', '{4}');".format(resultName, randint(1, 100), randint(100, 100000), color_type[randint(0, 5)], randint(1, 10)))
        connection.commit()

    for i in range(1000):
        name = fake.name()
        names = name.split(' ')
        firstName = names[0]
        secondName = names[1]
        print(fake.date_time_this_century())
        cursor.execute(
            "INSERT INTO deals(seller_id, buyer_id, sold_item_id, date, has_delivery, set_buyer_rating) VALUES({0}, {1}, {2}, '{3}', {4}, '{5}');".format(
                randint(1, 999), randint(1, 999), randint(1, 999), fake.date_time_this_century(), bool(getrandbits(1)), str(randint(1, 5))))
        connection.commit()

except (Exception, Error) as error:
    print("Ошибка при работе с PostgreSQL", error)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("Соединение с PostgreSQL закрыто")


# if __name__ == '__main__':
#     print_hi('PyCharm')


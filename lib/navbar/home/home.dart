import 'package:flutter/material.dart';
import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/model/book_service.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:gongdong/widgets/scrollablebook.dart';
import 'package:gongdong/wishlist/wishlist.dart';
import '../../widgets/customcard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;

  BookService bookService = BookService();
  List<BookModel> trendingBooks = [];
  List<BookModel> topHitsBooks = [];
  List<BookModel> newBooks = [];
  List<BookModel> allBooks = [];
  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  void loadBooks() async {
    setState(() {
      isLoading = true;
    });

    var trending = await bookService.fetchBooks('Trending+หนังสือ');
    var hits = await bookService.fetchBooks('หนังสือยอดฮิต');
    var latest = await bookService.fetchBooks('แปลนิยาย');

    if (!mounted) return;

    setState(() {
      trendingBooks = trending;
      topHitsBooks = hits;
      newBooks = latest;
      isLoading = false;
    });
    debugPrint('โหลดหนังสือสำเร็จ: ${trendingBooks.length} เล่ม');
    debugPrint('โหลดหนังสือสำเร็จ: ${hits.length} เล่ม');
    debugPrint('โหลดหนังสือสำเร็จ: ${latest.length} เล่ม');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 51, 50, 55),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 40,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ข่าวสาร',
                    style: TextStyle(
                      fontFamily: 'supermarket',
                      fontSize: 38,
                      color: Appcolors.creamywhiteColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Wishlist();
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Icon(
                                Icons.star,
                                color: Appcolors.creamywhiteColor,
                                size: 26,
                              ),
                            ),
                            Text(
                              'Wishlist',
                              style: TextStyle(
                                color: Appcolors.creamywhiteColor,
                                fontSize: 30,
                                fontFamily: 'supermarket',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Color.fromARGB(255, 230, 230, 222), thickness: 2),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomCard(
                  image:
                      //'https://scontent.fbkk15-1.fna.fbcdn.net/v/t39.30808-6/647482164_1354019870078521_4634426221041447779_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=13d280&_nc_eui2=AeGKYDkciSxtOaFhYoNVFuQEPqPzATa7ZG4-o_MBNrtkbhBSBeAUv97MLcuIzDFCdeTKOiEE_8l18b_0p3zHId30&_nc_ohc=1zyRIf28sMgQ7kNvwF_fYxU&_nc_oc=AdmgfYS_ZQSThSDESY6m1-bbTBIqAzt_HhXu6-zxGAQ4-bpY93JZJdKNr1ZT3V76ErM&_nc_zt=23&_nc_ht=scontent.fbkk15-1.fna&_nc_gid=NcxmexDbO2tazNCszI1CZA&_nc_ss=8&oh=00_AfyuTjqBgGoCuerbK-kE10oa-YkDUKf36odR3NInwSIzxg&oe=69B29898',
                      'https://shoppinglist.xiteb.com/assets/uploads/vendors/1719571780.jpg',
                  title:
                      '𝐏𝐑𝐄-𝐎𝐑𝐃𝐄𝐑 infinite Sorrow หากลืมตาจะเห็นฟ้าผ่าเป็นห่ารัก',
                  description:
                      'หากเคยรู้สึกว่าการเป็นตัวเองในโลกนี้มันยากเหลือทน ลองเงยหน้ามอง ‘ฟ้า’ ',
                ),
                CustomCard(
                  image:
                      //'https://scontent.fbkk15-1.fna.fbcdn.net/v/t39.30808-6/645470791_1337989228365824_2287847225900976992_n.jpg?stp=cp6_dst-jpg_tt6&_nc_cat=105&ccb=1-7&_nc_sid=13d280&_nc_eui2=AeGiAEoLwT5k-3CKR6v56bVugm8gwws3KiCCbyDDCzcqIFQe5liPqYPVB8_1b6yQHUF4iYiVQo-whRM4VSAqO_Zi&_nc_ohc=jfiidfEr_bYQ7kNvwEtelLP&_nc_oc=AdmbhIjzCbokjXSXz65F5Sbr1stqQ75BrCVe62ooSkvT2qBazfWZh26IVJO4ueQ2chg&_nc_zt=23&_nc_ht=scontent.fbkk15-1.fna&_nc_gid=Dy8flj2Ue7NN7l8ausJHXw&_nc_ss=8&oh=00_AfwFd31MmZ284qo644_wtxouqOOBIPuBnpqOdMQefqNGTg&oe=69B2C15E',
                      'https://shoppinglist.xiteb.com/assets/uploads/vendors/1719571780.jpg',
                  title: 'HIDDEN LAYER ประวัติศาสตร์ข้างหลังภาพ',
                  description:
                      'พบกันได้ที่แรกในงานสัปดาห์หนังสือแห่งชาติ บูธ M16 วันที่ 26 มีนาคม - 6 เมษายน 2569',
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomCard(
                  image:
                      //'https://scontent.fbkk15-1.fna.fbcdn.net/v/t39.30808-6/591414425_824221447118746_7780624084412099703_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=13d280&_nc_eui2=AeEZPm8PHTiiGPtMKCUHeufxe4CaUHytvZR7gJpQfK29lPiL2qMOtrjTOHnt4jcg8qig9fit9HnbcJWgj7euwMNE&_nc_ohc=IcT9LRM1w64Q7kNvwFxBNuJ&_nc_oc=Adkc-Ys0_UYk1DA6aEmzUGOu9s8b_gpBMpJChzI_KSUs3Dm9DI5k_G4aOpmbqqTo98Y&_nc_zt=23&_nc_ht=scontent.fbkk15-1.fna&_nc_gid=gxd9VRKzWM_3iQaj4gfXog&_nc_ss=8&oh=00_AfyQXlm2GWomlWk5OAzvvLEXIFo2PX8r5gfaTJDjaCfsgA&oe=69B298D4',
                      'https://shoppinglist.xiteb.com/assets/uploads/vendors/1719571780.jpg',
                  title: 'มยุรา ยะทา',
                  description:
                      'วิวาทะที่ดังที่สุดของข้อถกเถียงนี้ คือคำกล่าวของสมาคมปืนไรเฟิลแห่งชาติสหรัฐที่กล่าวว่า Gun don’t kill, People do',
                ),
                CustomCard(
                  image:
                      //'https://scontent.fbkk15-1.fna.fbcdn.net/v/t39.30808-6/646490229_1398034525671793_6359020911968657772_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=13d280&_nc_eui2=AeF_tYHgadQVH_zajWoHxzxleG02uGApSbl4bTa4YClJualBVemX89pe-Sf8EYk8Utp37rh8EX21ha7KwodAuwpG&_nc_ohc=d5DWGZcZ1A0Q7kNvwE_WeGa&_nc_oc=AdmI1u5suW9NnW7ttSy1dwU2XmUsfwmFmnHDNwGcHJcPDYwjwzM5yHaz5-UgEjzHODE&_nc_zt=23&_nc_ht=scontent.fbkk15-1.fna&_nc_gid=zDI24oLl-TMn7HQxwSgarQ&_nc_ss=8&oh=00_AfyApiqdYReIHqHEIzqE39siDzUEG4EZKWVc38n51wiHkA&oe=69B2A350',
                      'https://shoppinglist.xiteb.com/assets/uploads/vendors/1719571780.jpg',
                  title: 'แจ้งนิยายที่หมดสัญญาลิขสิทธิ์ piccolopublishing',
                  description: 'สำนักพิมพ์ขอแจ้งนิยายที่หมดสัญญาลิขสิทธิ์',
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Scrollablebook(
                  text: 'กำลังมาแรง',
                  itemCount: trendingBooks,
                  width: 100,
                  separatorwidth: 15,
                ),
                Scrollablebook(
                  text: 'ฮิตติดท็อป',
                  itemCount: topHitsBooks,
                  width: 100,
                  separatorwidth: 15,
                ),
                Scrollablebook(
                  text: 'มาใหม่',
                  itemCount: newBooks,
                  width: 100,
                  separatorwidth: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

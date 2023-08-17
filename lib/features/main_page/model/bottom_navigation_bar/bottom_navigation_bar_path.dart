import 'dart:ui';

class BottomNavBarPath {
  static Path getBottomNavBarPath(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.2250000);
    path.quadraticBezierTo(size.width * 0.7000250, size.height * 0.0998000,
        size.width * 0.6252625, size.height * 0.4000000);
    path.cubicTo(
        size.width * 0.5000500,
        size.height * 0.9497000,
        size.width * 0.5000375,
        size.height * 0.9502000,
        size.width * 0.3750125,
        size.height * 0.4000000);
    path.quadraticBezierTo(size.width * 0.3000500, size.height * 0.1005000, 0,
        size.height * 0.2250000);
    path.lineTo(0, size.height);
    return path;
  }
  /*
  class RPSCustomPainter extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
     
         
    Path path0 = Path();
    path0.moveTo(0,size.height);
    path0.lineTo(size.width,size.height);
    path0.lineTo(size.width,size.height*0.2250000);
    path0.quadraticBezierTo(size.width*0.7000250,size.height*0.0998000,size.width*0.6252625,size.height*0.4000000);
    path0.cubicTo(size.width*0.5000500,size.height*0.9497000,size.width*0.5000375,size.height*0.9502000,size.width*0.3750125,size.height*0.4000000);
    path0.quadraticBezierTo(size.width*0.3000500,size.height*0.1005000,0,size.height*0.2250000);
    path0.lineTo(0,size.height);
    path0.close();

    canvas.drawPath(path0, paint0);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}


   */
}

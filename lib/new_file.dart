void main(){

  void voidCall(){
    print("Void Called");
  }

  void withParams(int g){
    print(g);
  }

  int withReturn(int f){
    f = f+6;
    return f;
  }

  voidCall();

  withParams(6);

  int r = withReturn(2);
  print(r);

}
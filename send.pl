#!/usr/bin/perl

use CGI;
use Encode;
use UTF8;
use MIME::Base64::Perl;
use Net::XMPP;


#TestLine='�����������娸����������������������������������������������������';

# print &TranslateWin1251ToUni($TestLine)."\n";


sub isdigit {
  my($string)=shift;
  $string=~/^\d+$/; 
}

sub TranslateWin1251ToUni{
         my @ChArray=split('',$_[0]);
         my $Unicode='';
         my $Code='';
         for(@ChArray){
                 $Code=ord;
                 if(($Code>=0xc0)&&($Code<=0xff)){$Unicode.="&#".(0x350+$Code).";";}
                 elsif($Code==0xa8){$Unicode.="&#".(0x401).";";}
                 elsif($Code==0xb8){$Unicode.="&#".(0x451).";";}
                 else{$Unicode.=$_;}}
         return $Unicode;
}


sub to_utf8
{
my $data = shift();
my $charset = shift();

my $ref = ref( $data );
require Encode;

if( $ref eq 'SCALAR' )
{
## no critic Subroutines::ProtectPrivateSubs
Encode::_utf8_off( ${$data} );
Encode::from_to( ${$data}, $charset, 'utf8' );
Encode::_utf8_on( ${$data} );
## use critic Subroutines::ProtectPrivateSubs
}
elsif( $ref eq 'HASH' )
{
foreach my $value ( values( %{$data} ) )
{
next() unless defined( $value );
to_utf8( ref( $value ) ? $value : \$value, $charset );
}
}
elsif( $ref eq 'ARRAY' )
{
foreach my $value ( @{$data} )
{
next() unless defined( $value );
to_utf8( ref( $value ) ? $value : \$value, $charset );
}
}

return;
}




$COMMENT=CGI::param("COMMENT");
$target = CGI::param("target");
$phones  = CGI::param("phones");
$email  = CGI::param("email");
$name   = CGI::param("name");



#---------------------------------------------------------------------------------------------------------

      my @timeParts=localtime; 
    my ($my_day, $my_month, $my_year) = ($timeParts[3],$timeParts[4],$timeParts[5]); 
	$my_year+=1900;

	if ((length($COMMENT)> 0)  && (length($name) > 0) && (length($target) > 0) && (length($phones) > 6 ) && isdigit($phones)){
		open (CHECKBOOK, ">> c:/xampp/log_zhaloba" );	                                                        
		print CHECKBOOK  $COMMENT;	
		close CHECKBOOK;

		$msg_body ="������   $my_day.$my_month.$my_year \n      ���  $name   �������: $phones \n  ���� ������: $target\n   " . $COMMENT;
		$msg_subj ="������ $mydate \n�.�.�.:  $name   �������: $phones   \n���� ������: $target\n"   ;
		to_utf8( \$msg_body, 'windows-1251' );
		to_utf8( \$msg_subj, 'windows-1251' );

                $con=new Net::XMPP::Client();
		$con->Connect(hostname=>"xxx.xmpp.local");
		$con->AuthSend(username=>"registry",
                        password=>"xxxxx",
                        resource=>"Registry");
		my $msg=new Net::XMPP::Message();
		$msg->SetMessage(to=>"eugen\@xxx.xmpp.local",
                from=>"registry\@xxx.xmpp.local",
	        subject=>$msg_subj,
                body=>$msg_body);
		$con->Send($msg);

		$recepient="mr.first\@xxx.xmpp.local";
		to_utf8(\$recepient, 'windows-1251');
		$msg->SetMessage(to=>$recepient,
                from=>"registry\@xxx.xmpp.local",
	        subject=>$msg_subj,
                body=>$msg_body);
		$con->Send($msg);



		my $recepient="ms.first\@xxx.xmpp.local";
		to_utf8(\$recepient, 'windows-1251');
		$msg->SetMessage(to=>$recepient,
                from=>"registry\@xxx.xmpp.local",
	        subject=>$msg_subj,
                body=>$msg_body);
		$con->Send($msg);

		$recepient="mr.second\@xxx.xmpp.local";
		to_utf8(\$recepient, 'windows-1251');
		$msg->SetMessage(to=>$recepient,
                from=>"registry\@xxx.xmpp.local",
	        subject=>$msg_subj,
                body=>$msg_body);
		$con->Send($msg);

		$recepient="ms.second\@xxx.xmpp.local";
		to_utf8(\$recepient, 'windows-1251');
		$msg->SetMessage(to=>$recepient,
                from=>"registry\@xxx.xmpp.local",
	        subject=>$msg_subj,
                body=>$msg_body);
		$con->Send($msg);

		$con->Disconnect();

	



print "Content-type: text/html\n\n";

print <<HTML;
<html>
<head><title>31337 Penguin </title>
<META  CHARSET="Windows-1251">
<meta http-equiv="refresh" content="7; url=./autodvor.html">
</head>
<body>
	<A href="http://www.avtodvor.com">
	<IMG src="/images/avtodvor.jpg"  WIDTH="270" HEIGHT="70" ALIGN="right" BORDER="0" ALT="��������">
	</A>
<br>



<font color=#000000 size=2 face="Verdana"> ���� ��������� � ��������� ������� ����������: <br>  



       $COMMENT</font>


</body>
</html>
HTML
}
else{

print "Content-type: text/html\n\n";

print <<HTML_ERROR;
<html>
<head><title>������!!!! ��������� �� ��� ����!!!   </title>
<META  CHARSET="Windows-1251">
<meta http-equiv="refresh" content="7; url=./autodvor.html">
</head>
<body>
	<A href="http://www.avtodvor.com">
	<IMG src="/images/avtodvor.jpg"  WIDTH="270" HEIGHT="70" ALIGN="right" BORDER="0" ALT="��������">
	</A>
<br>
<font color=#000000 size=2 face="Verdana">

<b>������!!!! </b> ��������� �� ��� ����!!!  <br> ����������, ��������� ��������� ��������� ����: <b> ���� ������, �.�.�., ������� </b> <br>
(����� �������� ������ �������� ������ �� ����)


</body>
</html>
HTML_ERROR


}



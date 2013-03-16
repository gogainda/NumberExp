module TestHelpers
  def facebook_successful_auth_response
    OmniAuth::AuthHash.new(
      {
        "provider" => "facebook",
        "uid"      => "20012479",
        "info"=> {
                  "nickname"   => "adrian.artiles.12",
                  "email"      => "adrian.r.artiles@gmail.com",
                  "name"       => "Adrian Artiles",
                  "first_name" => "Adrian",
                  "last_name"  => "Artiles",
                  "image"      => "http://graph.facebook.com/20012479/picture?type=square",
                  "urls"       => { "Facebook" => "http://www.facebook.com/adrian.artiles.12" },
                  "verified"   => true
                  },
        "credentials"=> {
                          "token"      => "AAAYgDIvRpR4BACXiXJRBDJX5BsZCnzFyZA05cztEO0oPLIue72ZCsiJuuuCHNRLSYP4B9bfhlsuaPWFuGvvBiwu3S3Y1GSE6C1KMF5ZCvQZDZD",
                          "expires_at" => 1368584591,
                          "expires"    => true
                        },
        "extra"=> {
                    "raw_info"=> {
                                  "id"           => "20012479",
                                  "name"         => "Adrian Artiles",
                                  "first_name"   => "Adrian",
                                  "last_name"    => "Artiles",
                                  "link"         => "http://www.facebook.com/adrian.artiles.12",
                                  "username"     => "adrian.artiles.12",
                                  "gender"       => "male",
                                  "email"        => "adrian.r.artiles@gmail.com",
                                  "timezone"     => -5,
                                  "locale"       => "en_US",
                                  "verified"     => true,
                                  "updated_time" => "2013-03-12T03:56:06+0000"
                                  }
                  }
      })
  end
end

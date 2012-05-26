package Plack::Middleware::Session::RemoveCookies;
# ABSTRACT: remove cookies from the requests

use strict;
use warnings;
use Plack::Request;
use HTTP::Headers::Util qw(join_header_words);
use Plack::Util::Accessor 'key';

use parent 'Plack::Middleware';

sub call {
  my ( $self, $env ) = @_;

  if ( $env->{'HTTP_COOKIE'} ) {
    my $cookie = Plack::Request->new($env)->cookies;
    foreach my $c_key ( keys %$cookie ) {
      delete $cookie->{$c_key} if $c_key =~ $self->key;
    }
    $env->{'plack.cookie.string'} = $env->{'HTTP_COOKIE'}
      = join_header_words(%$cookie);
  }

  return $self->app->($env);
}

1;

__END__

=head1 SYNOPSIS

    enable 'Session::RemoveCookies', key => qr{plack_session}i;

    or

    enable_if {
        $_[0]->{'HTTP_X_DO-NOT-TRACK'} || $_[0]->{'HTTP_DNT'}
    } 'Session::RemoveCookies', key => qr{plack_session}i;

=head1 ACKNOWLEDGMENT

Initial development sponsored by 123people Internetservices GmbH - L<http://www.123people.com/>

=head1 SEE ALSO

L<Plack::Middleware>,  L<Plack::Builder>

=cut

package HTML::FormFu::Declare;
use Mouse;
use 5.00800;
our $VERSION = '0.01';
use Exporter 'import';
use HTML::FormFu;

our @EXPORT = qw/form field get Email method action Text Password Submit/;

our $_FORM_TEMP;
our $FORM;
sub form {
    my ($name, $cb) = @_;
    local $_FORM_TEMP;
    $cb->();
    $FORM->{caller(0)}->{$name} = $_FORM_TEMP;
}

sub field {
    my ($name, $opt) = @_;
    $opt->{name} = $name;
    push @{$_FORM_TEMP->{elements}}, $opt;
}

sub method {
    my $method = shift;
    $_FORM_TEMP->{method} = $method;
}

sub action {
    my $action = shift;
    $_FORM_TEMP->{action} = $action;
}

sub get {
    my ($class, $name) = @_;
    my $src = $FORM->{$class}->{$name};
    HTML::FormFu->new($src);
}

sub Email {
    my %attr = @_;
    push @{$attr{constraints}}, 'Email';
    Text(%attr);
}

sub Submit {
    _base(@_, 'type' => 'Submit');
}

sub Password {
    my %attr = @_;
    _base(%attr, type => 'Password');
}

sub Text {
    my %attr = @_;

    _base(%attr, type => 'Text');
}

sub _base {
    my %attr = @_;

    if (delete $attr{required}) {
        push @{$attr{constraints}}, 'Required';
    }
    \%attr;
}

1;
__END__

=head1 NAME

HTML::FormFu::Declare -

=head1 SYNOPSIS

    package YourApp::Form::User;
    use HTML::FormFu::Declare;

    form 'signup' => sub {
        auto_fieldset 1;

        field 'name' => Text{
            label => 'name',
        };
        field 'email' => Email{
            label => 'mail address',
        };
        field 'submit' => Submit(
            value => 'signup!'
        );
    };
    
    package YourApp::C::Signup;

    sub phase1 {
        my $c = shift;
        my $form = $c->form('User')->get('signup', model => $c->model('User'));
        if ($c->req->is_post_request) {
            if ($form->is_valid) {
                $form->model->save;
                return redirect('/signup/phase2');
            } else {
                return render(form => $form);
            }
        } else {
            return render(form => $form);
        }
    }

=head1 DESCRIPTION

HTML::FormFu::Declare is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

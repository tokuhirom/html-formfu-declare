use strict;
use warnings;
use Test::More tests => 2;

{
    package My::Form::User;
    use HTML::FormFu::Declare;

    my $common = sub {
        field 'name' => Email(
            label => 'mail address',
            required => 1,
        );
        field 'password' => Password(
            label => 'Password',
            required => 1,
        );
    };

    form 'signup' => sub {
        method 'post';
        action '/signup';

        field 'login_id' => Text(
            label => 'login id',
            required => 1,
        );
        $common->();
        field 'submit' => Submit(
            value => 'submit',
        );
    };

    form 'edit' => sub {
        method 'post';
        action '/my/edit';
        $common->();
        field 'submit' => Submit(
            value => 'edit',
        );
    };
}

is(My::Form::User->get('signup')->render, <<"...");
<form action="/signup" method="post">
<div class="text label">
<label>login id</label>
<input name="login_id" type="text" />
</div>
<div class="text label">
<label>mail address</label>
<input name="name" type="text" />
</div>
<div class="password label">
<label>Password</label>
<input name="password" type="password" />
</div>
<div class="submit">
<input name="submit" type="submit" value="submit" />
</div>
</form>
...

is(My::Form::User->get('edit')->render, <<"...");
<form action="/my/edit" method="post">
<div class="text label">
<label>mail address</label>
<input name="name" type="text" />
</div>
<div class="password label">
<label>Password</label>
<input name="password" type="password" />
</div>
<div class="submit">
<input name="submit" type="submit" value="edit" />
</div>
</form>
...


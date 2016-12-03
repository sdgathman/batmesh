Name:		batmesh
Version:	0.2
Release:	1%{?dist}
Summary:	Configure batman mesh for NetworkManager

Group:		Applications/System
License:	GPLv2+
URL:		https://github.com/sdgathman/batmesh/
Source0:	https://github.com/sdgathman/batmesh/archive/batmesh-%{version}.tar.gz

#BuildRequires:	
Requires:	batctl
Buildarch:	noarch

%description
Auto-configure BATMAN-ADV mesh 

%prep
%setup -q 

%build

%install
mkdir -p %{buildroot}%{_sysconfdir}/sysconfig
mkdir -p %{buildroot}%{_sysconfdir}/NetworkManager/dispatcher.d
install -pm 644 batmesh.conf \
	%{buildroot}%{_sysconfdir}/sysconfig/batmesh
install -pm 755 batman.sh \
	%{buildroot}%{_sysconfdir}/NetworkManager/dispatcher.d/05-batman

%files
%{!?_licensedir:%global license %%doc}
%license LICENSE
%doc README.md
%config(noreplace) %{_sysconfdir}/sysconfig/batmesh
%config(noreplace) %{_sysconfdir}/NetworkManager/dispatcher.d/*

%changelog

* Tue Nov  8 2016 Stuart Gathman <stuart@gathman.org> 0.2-1
- Include dnsmasq
- Fix 05-batman reference to /etc/sysconfig/batmesh

* Mon Nov  7 2016 Stuart Gathman <stuart@gathman.org> 0.1-1
- Initial package

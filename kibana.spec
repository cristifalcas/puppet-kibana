#rpmbuild -ba SPECS/kibana.spec
#%define prerelease_tag beta3
%define debug_package %{nil}

Summary:	visualize logs and time-stamped data
Name:		kibana
Version:	4.1.2
#Release:	1.%{prerelease_tag}%{?dist}
Release:	1%{?dist}
License:	Apache
Group:		Elasticsearch/kibana
#Source0:	https://download.elasticsearch.org/%{name}/%{name}/%{name}-%{version}-%{prerelease_tag}.zip
Source0:	https://download.elastic.co/%{name}/%{name}/%{name}-%{version}-linux-x64.tar.gz
URL:		http://www.elasticsearch.org/overview/kibana/

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%define installpath /opt/%{name}/

%description
%{summary}

%prep
%setup -q -n %{name}-%{version}-linux-x64

%pre

%post

%preun

%postun

%build
# Empty section.

%install
%{__rm} -rf %{buildroot}
install -d %{buildroot}%{installpath}
/bin/cp -a * %{buildroot}%{installpath}
find %{buildroot}%{installpath} -type f -iname \*.bat -exec chmod -x {} \;


%clean
%{__rm} -rf %{buildroot}


%files
%dir %{installpath}
%{installpath}*


%changelog
* Mon Jan 13 2014 ver 1.0
- First Build

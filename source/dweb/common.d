module dweb.common;
/**
	获取所有子类
*/
ClassInfo[] getChildClasses(ClassInfo c)
{
	ClassInfo[] info;
	foreach(mod; ModuleInfo)
	{
		foreach(cla; mod.localClasses)
		{
			if(cla.base is c)
			{
				info ~= cla;
			}
		}
	}
	return info;
}
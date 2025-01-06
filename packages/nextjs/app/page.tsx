"use client";

import type { NextPage } from "next";

const Home: NextPage = () => {
  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        <h1 className="text-center">
          <span className="block text-4xl font-bold">Welcome to SplitCoin!</span>
        </h1>
        <div className="max-w-3xl">
          <p className="text-center text-lg mx-10">
            <b className="text-xl">SplitCoin</b> is an app where you can share expenses with your friends. You can
            create a project to split expenses for a birthday, a marriage or any project!
          </p>
          <p className="text-left text-lg mx-10">
            <span className="block text-xl mb-2 font-bold">The steps are:</span>
            1. Create a project
            <br />
            2. Select the project you have created
            <br />
            3. Enter the participants with whom you want to share expenses
            <br />
            4. Enter the expenses
            <br />
            5. Once you have entered all the expenses, you can go to calculate to see who pays who. If you have to pay
            you will see the &quot;pay&quot; button together with the amount.
          </p>
        </div>
      </div>
    </>
  );
};

export default Home;

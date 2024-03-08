-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_249 is
end project_tb_249;

architecture project_tb_arch_249 of project_tb_249 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 275;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (21,0,103,0,248,0,44,0,145,0,169,0,82,0,32,0,52,0,0,0,128,0,59,0,9,0,212,0,1,0,55,0,249,0,69,0,0,0,64,0,230,0,211,0,241,0,254,0,243,0,251,0,229,0,192,0,70,0,241,0,6,0,154,0,86,0,238,0,76,0,0,0,164,0,5,0,23,0,0,0,182,0,203,0,182,0,0,0,179,0,34,0,219,0,70,0,11,0,99,0,0,0,240,0,0,0,61,0,181,0,174,0,152,0,67,0,16,0,184,0,37,0,120,0,34,0,203,0,150,0,166,0,120,0,240,0,130,0,38,0,0,0,100,0,28,0,101,0,38,0,7,0,94,0,50,0,106,0,0,0,146,0,0,0,211,0,209,0,194,0,0,0,48,0,163,0,249,0,0,0,44,0,94,0,78,0,65,0,0,0,88,0,126,0,0,0,0,0,185,0,196,0,122,0,71,0,0,0,0,0,0,0,0,0,179,0,0,0,184,0,0,0,0,0,195,0,0,0,0,0,88,0,3,0,99,0,52,0,119,0,191,0,53,0,0,0,59,0,168,0,135,0,120,0,49,0,84,0,210,0,25,0,165,0,56,0,0,0,59,0,56,0,193,0,146,0,0,0,0,0,83,0,102,0,234,0,39,0,168,0,97,0,69,0,243,0,50,0,102,0,74,0,82,0,216,0,38,0,0,0,105,0,14,0,55,0,98,0,109,0,250,0,54,0,210,0,82,0,17,0,100,0,153,0,238,0,129,0,216,0,0,0,111,0,75,0,128,0,0,0,53,0,228,0,35,0,117,0,147,0,8,0,2,0,0,0,87,0,93,0,0,0,0,0,246,0,228,0,0,0,49,0,90,0,26,0,131,0,147,0,204,0,172,0,163,0,36,0,144,0,237,0,45,0,182,0,190,0,57,0,122,0,0,0,36,0,0,0,132,0,167,0,238,0,241,0,129,0,198,0,191,0,32,0,71,0,93,0,225,0,0,0,8,0,0,0,154,0,129,0,130,0,170,0,166,0,248,0,59,0,114,0,190,0,0,0,0,0,22,0,88,0,144,0,0,0,158,0,45,0,0,0,0,0,0,0,251,0,99,0,225,0,84,0,12,0,114,0,252,0,0,0,35,0,126,0,111,0,227,0,0,0,202,0,118,0,0,0,164,0,93,0,253,0,115,0,160,0,0,0,29,0,152,0,0,0,171,0,253,0,45,0,112,0,211,0,0,0,84,0);
signal scenario_full  : scenario_type := (21,31,103,31,248,31,44,31,145,31,169,31,82,31,32,31,52,31,52,30,128,31,59,31,9,31,212,31,1,31,55,31,249,31,69,31,69,30,64,31,230,31,211,31,241,31,254,31,243,31,251,31,229,31,192,31,70,31,241,31,6,31,154,31,86,31,238,31,76,31,76,30,164,31,5,31,23,31,23,30,182,31,203,31,182,31,182,30,179,31,34,31,219,31,70,31,11,31,99,31,99,30,240,31,240,30,61,31,181,31,174,31,152,31,67,31,16,31,184,31,37,31,120,31,34,31,203,31,150,31,166,31,120,31,240,31,130,31,38,31,38,30,100,31,28,31,101,31,38,31,7,31,94,31,50,31,106,31,106,30,146,31,146,30,211,31,209,31,194,31,194,30,48,31,163,31,249,31,249,30,44,31,94,31,78,31,65,31,65,30,88,31,126,31,126,30,126,29,185,31,196,31,122,31,71,31,71,30,71,29,71,28,71,27,179,31,179,30,184,31,184,30,184,29,195,31,195,30,195,29,88,31,3,31,99,31,52,31,119,31,191,31,53,31,53,30,59,31,168,31,135,31,120,31,49,31,84,31,210,31,25,31,165,31,56,31,56,30,59,31,56,31,193,31,146,31,146,30,146,29,83,31,102,31,234,31,39,31,168,31,97,31,69,31,243,31,50,31,102,31,74,31,82,31,216,31,38,31,38,30,105,31,14,31,55,31,98,31,109,31,250,31,54,31,210,31,82,31,17,31,100,31,153,31,238,31,129,31,216,31,216,30,111,31,75,31,128,31,128,30,53,31,228,31,35,31,117,31,147,31,8,31,2,31,2,30,87,31,93,31,93,30,93,29,246,31,228,31,228,30,49,31,90,31,26,31,131,31,147,31,204,31,172,31,163,31,36,31,144,31,237,31,45,31,182,31,190,31,57,31,122,31,122,30,36,31,36,30,132,31,167,31,238,31,241,31,129,31,198,31,191,31,32,31,71,31,93,31,225,31,225,30,8,31,8,30,154,31,129,31,130,31,170,31,166,31,248,31,59,31,114,31,190,31,190,30,190,29,22,31,88,31,144,31,144,30,158,31,45,31,45,30,45,29,45,28,251,31,99,31,225,31,84,31,12,31,114,31,252,31,252,30,35,31,126,31,111,31,227,31,227,30,202,31,118,31,118,30,164,31,93,31,253,31,115,31,160,31,160,30,29,31,152,31,152,30,171,31,253,31,45,31,112,31,211,31,211,30,84,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;

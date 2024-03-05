-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 384;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (194,0,91,0,162,0,69,0,122,0,0,0,99,0,10,0,0,0,26,0,57,0,34,0,21,0,0,0,136,0,217,0,33,0,0,0,242,0,27,0,164,0,7,0,230,0,182,0,33,0,215,0,173,0,133,0,213,0,126,0,180,0,64,0,92,0,3,0,5,0,100,0,169,0,245,0,49,0,161,0,0,0,51,0,26,0,0,0,0,0,67,0,160,0,160,0,117,0,28,0,89,0,72,0,112,0,180,0,31,0,59,0,205,0,189,0,0,0,161,0,109,0,84,0,33,0,0,0,130,0,0,0,223,0,145,0,245,0,211,0,0,0,232,0,247,0,26,0,0,0,129,0,148,0,135,0,57,0,151,0,177,0,0,0,81,0,161,0,210,0,174,0,0,0,135,0,231,0,107,0,0,0,0,0,1,0,0,0,84,0,88,0,216,0,0,0,0,0,169,0,0,0,60,0,213,0,35,0,103,0,167,0,13,0,0,0,0,0,177,0,0,0,56,0,206,0,240,0,0,0,19,0,35,0,0,0,0,0,0,0,0,0,111,0,168,0,98,0,53,0,113,0,153,0,139,0,0,0,146,0,217,0,64,0,0,0,0,0,225,0,29,0,12,0,154,0,16,0,167,0,151,0,152,0,10,0,0,0,36,0,218,0,0,0,137,0,232,0,138,0,52,0,212,0,0,0,7,0,249,0,152,0,0,0,168,0,119,0,148,0,0,0,222,0,21,0,171,0,90,0,3,0,4,0,59,0,121,0,245,0,0,0,194,0,0,0,0,0,223,0,190,0,0,0,147,0,150,0,0,0,126,0,163,0,42,0,151,0,115,0,9,0,239,0,0,0,0,0,212,0,235,0,155,0,242,0,100,0,125,0,157,0,0,0,0,0,88,0,3,0,0,0,110,0,1,0,0,0,0,0,186,0,0,0,112,0,74,0,189,0,171,0,179,0,252,0,0,0,143,0,54,0,28,0,106,0,74,0,141,0,39,0,168,0,0,0,113,0,69,0,177,0,92,0,0,0,206,0,174,0,222,0,122,0,162,0,150,0,30,0,83,0,40,0,74,0,84,0,108,0,129,0,138,0,122,0,32,0,33,0,0,0,111,0,237,0,148,0,197,0,60,0,95,0,117,0,0,0,233,0,196,0,183,0,20,0,226,0,186,0,130,0,149,0,98,0,0,0,179,0,35,0,72,0,0,0,7,0,60,0,246,0,0,0,155,0,92,0,175,0,192,0,0,0,0,0,172,0,85,0,54,0,210,0,144,0,204,0,53,0,162,0,92,0,6,0,192,0,68,0,76,0,210,0,166,0,187,0,27,0,0,0,102,0,19,0,167,0,78,0,0,0,0,0,0,0,0,0,151,0,180,0,0,0,235,0,84,0,138,0,178,0,28,0,68,0,28,0,232,0,0,0,15,0,0,0,105,0,50,0,44,0,231,0,180,0,0,0,165,0,144,0,53,0,0,0,0,0,90,0,123,0,0,0,88,0,67,0,0,0,244,0,62,0,92,0,80,0,101,0,127,0,203,0,0,0,85,0,0,0,0,0,245,0,129,0,93,0,27,0,0,0,223,0,228,0,4,0,67,0,146,0,132,0,110,0,0,0,0,0,121,0,166,0,198,0,173,0,187,0,213,0,51,0,0,0,247,0,197,0,0,0,17,0,92,0,198,0,47,0,0,0,0,0,0,0,0,0,76,0,249,0,233,0,203,0,0,0);
signal scenario_full  : scenario_type := (194,31,91,31,162,31,69,31,122,31,122,30,99,31,10,31,10,30,26,31,57,31,34,31,21,31,21,30,136,31,217,31,33,31,33,30,242,31,27,31,164,31,7,31,230,31,182,31,33,31,215,31,173,31,133,31,213,31,126,31,180,31,64,31,92,31,3,31,5,31,100,31,169,31,245,31,49,31,161,31,161,30,51,31,26,31,26,30,26,29,67,31,160,31,160,31,117,31,28,31,89,31,72,31,112,31,180,31,31,31,59,31,205,31,189,31,189,30,161,31,109,31,84,31,33,31,33,30,130,31,130,30,223,31,145,31,245,31,211,31,211,30,232,31,247,31,26,31,26,30,129,31,148,31,135,31,57,31,151,31,177,31,177,30,81,31,161,31,210,31,174,31,174,30,135,31,231,31,107,31,107,30,107,29,1,31,1,30,84,31,88,31,216,31,216,30,216,29,169,31,169,30,60,31,213,31,35,31,103,31,167,31,13,31,13,30,13,29,177,31,177,30,56,31,206,31,240,31,240,30,19,31,35,31,35,30,35,29,35,28,35,27,111,31,168,31,98,31,53,31,113,31,153,31,139,31,139,30,146,31,217,31,64,31,64,30,64,29,225,31,29,31,12,31,154,31,16,31,167,31,151,31,152,31,10,31,10,30,36,31,218,31,218,30,137,31,232,31,138,31,52,31,212,31,212,30,7,31,249,31,152,31,152,30,168,31,119,31,148,31,148,30,222,31,21,31,171,31,90,31,3,31,4,31,59,31,121,31,245,31,245,30,194,31,194,30,194,29,223,31,190,31,190,30,147,31,150,31,150,30,126,31,163,31,42,31,151,31,115,31,9,31,239,31,239,30,239,29,212,31,235,31,155,31,242,31,100,31,125,31,157,31,157,30,157,29,88,31,3,31,3,30,110,31,1,31,1,30,1,29,186,31,186,30,112,31,74,31,189,31,171,31,179,31,252,31,252,30,143,31,54,31,28,31,106,31,74,31,141,31,39,31,168,31,168,30,113,31,69,31,177,31,92,31,92,30,206,31,174,31,222,31,122,31,162,31,150,31,30,31,83,31,40,31,74,31,84,31,108,31,129,31,138,31,122,31,32,31,33,31,33,30,111,31,237,31,148,31,197,31,60,31,95,31,117,31,117,30,233,31,196,31,183,31,20,31,226,31,186,31,130,31,149,31,98,31,98,30,179,31,35,31,72,31,72,30,7,31,60,31,246,31,246,30,155,31,92,31,175,31,192,31,192,30,192,29,172,31,85,31,54,31,210,31,144,31,204,31,53,31,162,31,92,31,6,31,192,31,68,31,76,31,210,31,166,31,187,31,27,31,27,30,102,31,19,31,167,31,78,31,78,30,78,29,78,28,78,27,151,31,180,31,180,30,235,31,84,31,138,31,178,31,28,31,68,31,28,31,232,31,232,30,15,31,15,30,105,31,50,31,44,31,231,31,180,31,180,30,165,31,144,31,53,31,53,30,53,29,90,31,123,31,123,30,88,31,67,31,67,30,244,31,62,31,92,31,80,31,101,31,127,31,203,31,203,30,85,31,85,30,85,29,245,31,129,31,93,31,27,31,27,30,223,31,228,31,4,31,67,31,146,31,132,31,110,31,110,30,110,29,121,31,166,31,198,31,173,31,187,31,213,31,51,31,51,30,247,31,197,31,197,30,17,31,92,31,198,31,47,31,47,30,47,29,47,28,47,27,76,31,249,31,233,31,203,31,203,30);

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

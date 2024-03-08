-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_950 is
end project_tb_950;

architecture project_tb_arch_950 of project_tb_950 is
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

constant SCENARIO_LENGTH : integer := 335;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (58,0,242,0,214,0,92,0,169,0,57,0,197,0,142,0,184,0,128,0,101,0,96,0,131,0,173,0,0,0,8,0,69,0,241,0,168,0,71,0,0,0,164,0,0,0,2,0,200,0,177,0,3,0,184,0,229,0,41,0,56,0,178,0,27,0,243,0,0,0,63,0,0,0,158,0,0,0,106,0,148,0,159,0,77,0,0,0,123,0,0,0,132,0,135,0,55,0,248,0,0,0,89,0,150,0,12,0,254,0,0,0,153,0,189,0,51,0,126,0,240,0,131,0,11,0,225,0,0,0,121,0,126,0,93,0,34,0,188,0,10,0,196,0,214,0,152,0,115,0,67,0,0,0,146,0,157,0,26,0,49,0,19,0,44,0,167,0,225,0,217,0,71,0,163,0,218,0,176,0,147,0,49,0,144,0,1,0,0,0,0,0,135,0,215,0,89,0,188,0,163,0,196,0,223,0,116,0,40,0,239,0,0,0,0,0,147,0,98,0,2,0,21,0,2,0,250,0,0,0,148,0,141,0,0,0,43,0,85,0,23,0,242,0,216,0,0,0,103,0,136,0,35,0,0,0,0,0,0,0,191,0,63,0,78,0,143,0,0,0,188,0,0,0,0,0,44,0,32,0,240,0,70,0,195,0,126,0,138,0,65,0,64,0,0,0,185,0,159,0,196,0,17,0,201,0,0,0,0,0,0,0,179,0,170,0,0,0,239,0,0,0,54,0,23,0,133,0,111,0,69,0,0,0,205,0,141,0,223,0,151,0,12,0,214,0,36,0,51,0,244,0,70,0,27,0,88,0,107,0,41,0,137,0,5,0,116,0,3,0,83,0,76,0,194,0,239,0,28,0,247,0,247,0,0,0,43,0,221,0,0,0,231,0,111,0,206,0,8,0,0,0,39,0,0,0,146,0,0,0,42,0,115,0,24,0,0,0,0,0,116,0,0,0,41,0,67,0,234,0,159,0,0,0,247,0,174,0,176,0,198,0,0,0,39,0,217,0,240,0,66,0,63,0,0,0,198,0,1,0,0,0,4,0,164,0,0,0,12,0,29,0,49,0,168,0,233,0,0,0,0,0,99,0,218,0,0,0,46,0,144,0,190,0,202,0,32,0,245,0,0,0,211,0,108,0,187,0,0,0,211,0,0,0,168,0,255,0,53,0,142,0,172,0,64,0,0,0,0,0,214,0,5,0,13,0,0,0,116,0,33,0,179,0,97,0,9,0,100,0,175,0,0,0,119,0,61,0,98,0,162,0,129,0,0,0,56,0,60,0,233,0,0,0,0,0,24,0,245,0,126,0,71,0,96,0,11,0,0,0,0,0,87,0,14,0,231,0,176,0,184,0,172,0,153,0,239,0,198,0,221,0,178,0,191,0,148,0,246,0,227,0,125,0,147,0,65,0,141,0,128,0,157,0,189,0,115,0,148,0,73,0,0,0,0,0,38,0,36,0,0,0,240,0,104,0,112,0,231,0,81,0,0,0,37,0,178,0,0,0);
signal scenario_full  : scenario_type := (58,31,242,31,214,31,92,31,169,31,57,31,197,31,142,31,184,31,128,31,101,31,96,31,131,31,173,31,173,30,8,31,69,31,241,31,168,31,71,31,71,30,164,31,164,30,2,31,200,31,177,31,3,31,184,31,229,31,41,31,56,31,178,31,27,31,243,31,243,30,63,31,63,30,158,31,158,30,106,31,148,31,159,31,77,31,77,30,123,31,123,30,132,31,135,31,55,31,248,31,248,30,89,31,150,31,12,31,254,31,254,30,153,31,189,31,51,31,126,31,240,31,131,31,11,31,225,31,225,30,121,31,126,31,93,31,34,31,188,31,10,31,196,31,214,31,152,31,115,31,67,31,67,30,146,31,157,31,26,31,49,31,19,31,44,31,167,31,225,31,217,31,71,31,163,31,218,31,176,31,147,31,49,31,144,31,1,31,1,30,1,29,135,31,215,31,89,31,188,31,163,31,196,31,223,31,116,31,40,31,239,31,239,30,239,29,147,31,98,31,2,31,21,31,2,31,250,31,250,30,148,31,141,31,141,30,43,31,85,31,23,31,242,31,216,31,216,30,103,31,136,31,35,31,35,30,35,29,35,28,191,31,63,31,78,31,143,31,143,30,188,31,188,30,188,29,44,31,32,31,240,31,70,31,195,31,126,31,138,31,65,31,64,31,64,30,185,31,159,31,196,31,17,31,201,31,201,30,201,29,201,28,179,31,170,31,170,30,239,31,239,30,54,31,23,31,133,31,111,31,69,31,69,30,205,31,141,31,223,31,151,31,12,31,214,31,36,31,51,31,244,31,70,31,27,31,88,31,107,31,41,31,137,31,5,31,116,31,3,31,83,31,76,31,194,31,239,31,28,31,247,31,247,31,247,30,43,31,221,31,221,30,231,31,111,31,206,31,8,31,8,30,39,31,39,30,146,31,146,30,42,31,115,31,24,31,24,30,24,29,116,31,116,30,41,31,67,31,234,31,159,31,159,30,247,31,174,31,176,31,198,31,198,30,39,31,217,31,240,31,66,31,63,31,63,30,198,31,1,31,1,30,4,31,164,31,164,30,12,31,29,31,49,31,168,31,233,31,233,30,233,29,99,31,218,31,218,30,46,31,144,31,190,31,202,31,32,31,245,31,245,30,211,31,108,31,187,31,187,30,211,31,211,30,168,31,255,31,53,31,142,31,172,31,64,31,64,30,64,29,214,31,5,31,13,31,13,30,116,31,33,31,179,31,97,31,9,31,100,31,175,31,175,30,119,31,61,31,98,31,162,31,129,31,129,30,56,31,60,31,233,31,233,30,233,29,24,31,245,31,126,31,71,31,96,31,11,31,11,30,11,29,87,31,14,31,231,31,176,31,184,31,172,31,153,31,239,31,198,31,221,31,178,31,191,31,148,31,246,31,227,31,125,31,147,31,65,31,141,31,128,31,157,31,189,31,115,31,148,31,73,31,73,30,73,29,38,31,36,31,36,30,240,31,104,31,112,31,231,31,81,31,81,30,37,31,178,31,178,30);

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

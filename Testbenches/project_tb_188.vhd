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

constant SCENARIO_LENGTH : integer := 337;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (148,0,220,0,138,0,149,0,177,0,230,0,241,0,237,0,93,0,0,0,252,0,10,0,100,0,184,0,0,0,211,0,44,0,0,0,0,0,0,0,0,0,138,0,141,0,61,0,147,0,232,0,11,0,210,0,0,0,63,0,8,0,0,0,125,0,0,0,77,0,0,0,209,0,250,0,76,0,112,0,236,0,182,0,254,0,164,0,0,0,39,0,219,0,225,0,97,0,7,0,75,0,26,0,4,0,0,0,212,0,204,0,79,0,104,0,244,0,0,0,102,0,70,0,253,0,108,0,0,0,77,0,0,0,175,0,167,0,0,0,79,0,43,0,172,0,123,0,8,0,53,0,94,0,0,0,17,0,0,0,159,0,169,0,176,0,42,0,187,0,149,0,43,0,16,0,45,0,118,0,176,0,82,0,6,0,252,0,142,0,97,0,106,0,26,0,123,0,0,0,148,0,45,0,241,0,204,0,47,0,131,0,0,0,27,0,71,0,187,0,132,0,216,0,0,0,237,0,74,0,16,0,65,0,135,0,216,0,223,0,124,0,235,0,73,0,0,0,235,0,2,0,112,0,110,0,97,0,0,0,0,0,4,0,37,0,249,0,21,0,62,0,246,0,154,0,241,0,25,0,229,0,188,0,0,0,186,0,60,0,13,0,39,0,254,0,85,0,0,0,0,0,192,0,126,0,27,0,0,0,134,0,0,0,94,0,45,0,70,0,216,0,42,0,189,0,184,0,120,0,230,0,0,0,0,0,87,0,0,0,69,0,0,0,236,0,0,0,158,0,250,0,59,0,184,0,202,0,0,0,0,0,0,0,21,0,23,0,49,0,218,0,83,0,0,0,86,0,236,0,0,0,96,0,66,0,0,0,177,0,174,0,0,0,222,0,57,0,102,0,110,0,127,0,7,0,116,0,0,0,208,0,148,0,75,0,0,0,63,0,0,0,38,0,100,0,35,0,173,0,4,0,213,0,8,0,0,0,41,0,229,0,58,0,0,0,219,0,149,0,50,0,134,0,55,0,223,0,87,0,135,0,156,0,57,0,28,0,0,0,217,0,125,0,64,0,107,0,109,0,18,0,148,0,48,0,12,0,0,0,0,0,80,0,222,0,28,0,0,0,191,0,174,0,54,0,77,0,54,0,216,0,228,0,0,0,176,0,0,0,0,0,156,0,133,0,10,0,177,0,149,0,48,0,81,0,9,0,202,0,59,0,90,0,237,0,17,0,245,0,213,0,154,0,214,0,176,0,229,0,59,0,0,0,137,0,109,0,123,0,222,0,222,0,1,0,216,0,179,0,82,0,224,0,0,0,108,0,210,0,16,0,244,0,2,0,252,0,0,0,0,0,98,0,13,0,93,0,111,0,0,0,0,0,129,0,44,0,37,0,0,0,121,0,231,0,163,0,18,0,0,0,135,0,0,0,159,0,66,0,237,0,154,0,64,0,242,0,0,0,252,0,214,0,241,0,5,0,5,0,115,0,193,0,222,0,101,0,112,0,100,0,1,0);
signal scenario_full  : scenario_type := (148,31,220,31,138,31,149,31,177,31,230,31,241,31,237,31,93,31,93,30,252,31,10,31,100,31,184,31,184,30,211,31,44,31,44,30,44,29,44,28,44,27,138,31,141,31,61,31,147,31,232,31,11,31,210,31,210,30,63,31,8,31,8,30,125,31,125,30,77,31,77,30,209,31,250,31,76,31,112,31,236,31,182,31,254,31,164,31,164,30,39,31,219,31,225,31,97,31,7,31,75,31,26,31,4,31,4,30,212,31,204,31,79,31,104,31,244,31,244,30,102,31,70,31,253,31,108,31,108,30,77,31,77,30,175,31,167,31,167,30,79,31,43,31,172,31,123,31,8,31,53,31,94,31,94,30,17,31,17,30,159,31,169,31,176,31,42,31,187,31,149,31,43,31,16,31,45,31,118,31,176,31,82,31,6,31,252,31,142,31,97,31,106,31,26,31,123,31,123,30,148,31,45,31,241,31,204,31,47,31,131,31,131,30,27,31,71,31,187,31,132,31,216,31,216,30,237,31,74,31,16,31,65,31,135,31,216,31,223,31,124,31,235,31,73,31,73,30,235,31,2,31,112,31,110,31,97,31,97,30,97,29,4,31,37,31,249,31,21,31,62,31,246,31,154,31,241,31,25,31,229,31,188,31,188,30,186,31,60,31,13,31,39,31,254,31,85,31,85,30,85,29,192,31,126,31,27,31,27,30,134,31,134,30,94,31,45,31,70,31,216,31,42,31,189,31,184,31,120,31,230,31,230,30,230,29,87,31,87,30,69,31,69,30,236,31,236,30,158,31,250,31,59,31,184,31,202,31,202,30,202,29,202,28,21,31,23,31,49,31,218,31,83,31,83,30,86,31,236,31,236,30,96,31,66,31,66,30,177,31,174,31,174,30,222,31,57,31,102,31,110,31,127,31,7,31,116,31,116,30,208,31,148,31,75,31,75,30,63,31,63,30,38,31,100,31,35,31,173,31,4,31,213,31,8,31,8,30,41,31,229,31,58,31,58,30,219,31,149,31,50,31,134,31,55,31,223,31,87,31,135,31,156,31,57,31,28,31,28,30,217,31,125,31,64,31,107,31,109,31,18,31,148,31,48,31,12,31,12,30,12,29,80,31,222,31,28,31,28,30,191,31,174,31,54,31,77,31,54,31,216,31,228,31,228,30,176,31,176,30,176,29,156,31,133,31,10,31,177,31,149,31,48,31,81,31,9,31,202,31,59,31,90,31,237,31,17,31,245,31,213,31,154,31,214,31,176,31,229,31,59,31,59,30,137,31,109,31,123,31,222,31,222,31,1,31,216,31,179,31,82,31,224,31,224,30,108,31,210,31,16,31,244,31,2,31,252,31,252,30,252,29,98,31,13,31,93,31,111,31,111,30,111,29,129,31,44,31,37,31,37,30,121,31,231,31,163,31,18,31,18,30,135,31,135,30,159,31,66,31,237,31,154,31,64,31,242,31,242,30,252,31,214,31,241,31,5,31,5,31,115,31,193,31,222,31,101,31,112,31,100,31,1,31);

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

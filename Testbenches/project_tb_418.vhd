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

constant SCENARIO_LENGTH : integer := 472;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (14,0,0,0,0,0,40,0,77,0,205,0,200,0,71,0,251,0,0,0,115,0,0,0,103,0,142,0,0,0,114,0,168,0,68,0,74,0,0,0,0,0,113,0,214,0,62,0,195,0,27,0,0,0,102,0,0,0,76,0,208,0,93,0,0,0,95,0,0,0,0,0,206,0,196,0,175,0,0,0,0,0,26,0,205,0,145,0,49,0,16,0,226,0,189,0,193,0,5,0,234,0,110,0,24,0,59,0,95,0,47,0,225,0,92,0,54,0,249,0,66,0,0,0,0,0,0,0,3,0,7,0,16,0,16,0,17,0,126,0,237,0,219,0,0,0,138,0,44,0,0,0,195,0,121,0,163,0,33,0,99,0,204,0,233,0,218,0,144,0,54,0,95,0,92,0,205,0,231,0,135,0,119,0,177,0,206,0,27,0,168,0,133,0,1,0,218,0,98,0,13,0,240,0,16,0,29,0,206,0,79,0,85,0,59,0,153,0,56,0,137,0,0,0,13,0,148,0,105,0,0,0,93,0,61,0,36,0,63,0,80,0,0,0,214,0,242,0,0,0,245,0,0,0,169,0,150,0,0,0,172,0,0,0,28,0,0,0,213,0,179,0,155,0,153,0,0,0,0,0,130,0,41,0,55,0,55,0,175,0,0,0,41,0,147,0,0,0,40,0,108,0,20,0,120,0,189,0,226,0,90,0,163,0,158,0,0,0,145,0,0,0,7,0,0,0,103,0,100,0,229,0,141,0,0,0,107,0,119,0,0,0,254,0,42,0,35,0,33,0,8,0,182,0,54,0,174,0,7,0,107,0,76,0,214,0,31,0,233,0,194,0,0,0,128,0,28,0,21,0,163,0,17,0,0,0,127,0,142,0,18,0,175,0,133,0,0,0,164,0,0,0,208,0,238,0,200,0,0,0,46,0,91,0,25,0,0,0,0,0,62,0,201,0,0,0,205,0,222,0,172,0,190,0,3,0,104,0,107,0,166,0,170,0,53,0,186,0,1,0,0,0,133,0,42,0,177,0,46,0,158,0,4,0,0,0,0,0,0,0,154,0,27,0,59,0,209,0,0,0,88,0,128,0,209,0,25,0,151,0,107,0,30,0,177,0,10,0,0,0,168,0,187,0,114,0,72,0,1,0,153,0,26,0,1,0,196,0,110,0,32,0,226,0,76,0,0,0,187,0,222,0,157,0,65,0,0,0,0,0,0,0,32,0,146,0,0,0,111,0,18,0,76,0,142,0,42,0,3,0,0,0,62,0,244,0,230,0,148,0,212,0,111,0,243,0,141,0,0,0,7,0,212,0,21,0,65,0,254,0,248,0,0,0,48,0,73,0,254,0,141,0,183,0,230,0,255,0,0,0,100,0,0,0,36,0,0,0,131,0,147,0,26,0,0,0,51,0,26,0,58,0,0,0,0,0,174,0,191,0,176,0,7,0,171,0,180,0,134,0,135,0,207,0,230,0,253,0,159,0,0,0,0,0,60,0,241,0,114,0,0,0,10,0,166,0,221,0,0,0,28,0,205,0,221,0,16,0,0,0,100,0,189,0,7,0,4,0,177,0,99,0,54,0,167,0,0,0,129,0,0,0,212,0,8,0,51,0,89,0,158,0,0,0,181,0,25,0,0,0,0,0,219,0,0,0,207,0,249,0,122,0,31,0,212,0,0,0,210,0,241,0,212,0,13,0,29,0,209,0,232,0,0,0,254,0,0,0,57,0,218,0,245,0,245,0,146,0,181,0,56,0,168,0,0,0,191,0,19,0,149,0,43,0,65,0,235,0,82,0,121,0,0,0,119,0,0,0,201,0,34,0,9,0,250,0,24,0,9,0,0,0,5,0,0,0,129,0,151,0,64,0,104,0,236,0,0,0,64,0,0,0,43,0,34,0,253,0,0,0,0,0,0,0,0,0,130,0,220,0,89,0,184,0,217,0,83,0,202,0,140,0,194,0,0,0,0,0,0,0,210,0,235,0,0,0,0,0,27,0,201,0,0,0,245,0,44,0,49,0,0,0,0,0,33,0,99,0,252,0,188,0,181,0,0,0,50,0,171,0,148,0,30,0,138,0,108,0,237,0,155,0,183,0,0,0,79,0,85,0,0,0,0,0);
signal scenario_full  : scenario_type := (14,31,14,30,14,29,40,31,77,31,205,31,200,31,71,31,251,31,251,30,115,31,115,30,103,31,142,31,142,30,114,31,168,31,68,31,74,31,74,30,74,29,113,31,214,31,62,31,195,31,27,31,27,30,102,31,102,30,76,31,208,31,93,31,93,30,95,31,95,30,95,29,206,31,196,31,175,31,175,30,175,29,26,31,205,31,145,31,49,31,16,31,226,31,189,31,193,31,5,31,234,31,110,31,24,31,59,31,95,31,47,31,225,31,92,31,54,31,249,31,66,31,66,30,66,29,66,28,3,31,7,31,16,31,16,31,17,31,126,31,237,31,219,31,219,30,138,31,44,31,44,30,195,31,121,31,163,31,33,31,99,31,204,31,233,31,218,31,144,31,54,31,95,31,92,31,205,31,231,31,135,31,119,31,177,31,206,31,27,31,168,31,133,31,1,31,218,31,98,31,13,31,240,31,16,31,29,31,206,31,79,31,85,31,59,31,153,31,56,31,137,31,137,30,13,31,148,31,105,31,105,30,93,31,61,31,36,31,63,31,80,31,80,30,214,31,242,31,242,30,245,31,245,30,169,31,150,31,150,30,172,31,172,30,28,31,28,30,213,31,179,31,155,31,153,31,153,30,153,29,130,31,41,31,55,31,55,31,175,31,175,30,41,31,147,31,147,30,40,31,108,31,20,31,120,31,189,31,226,31,90,31,163,31,158,31,158,30,145,31,145,30,7,31,7,30,103,31,100,31,229,31,141,31,141,30,107,31,119,31,119,30,254,31,42,31,35,31,33,31,8,31,182,31,54,31,174,31,7,31,107,31,76,31,214,31,31,31,233,31,194,31,194,30,128,31,28,31,21,31,163,31,17,31,17,30,127,31,142,31,18,31,175,31,133,31,133,30,164,31,164,30,208,31,238,31,200,31,200,30,46,31,91,31,25,31,25,30,25,29,62,31,201,31,201,30,205,31,222,31,172,31,190,31,3,31,104,31,107,31,166,31,170,31,53,31,186,31,1,31,1,30,133,31,42,31,177,31,46,31,158,31,4,31,4,30,4,29,4,28,154,31,27,31,59,31,209,31,209,30,88,31,128,31,209,31,25,31,151,31,107,31,30,31,177,31,10,31,10,30,168,31,187,31,114,31,72,31,1,31,153,31,26,31,1,31,196,31,110,31,32,31,226,31,76,31,76,30,187,31,222,31,157,31,65,31,65,30,65,29,65,28,32,31,146,31,146,30,111,31,18,31,76,31,142,31,42,31,3,31,3,30,62,31,244,31,230,31,148,31,212,31,111,31,243,31,141,31,141,30,7,31,212,31,21,31,65,31,254,31,248,31,248,30,48,31,73,31,254,31,141,31,183,31,230,31,255,31,255,30,100,31,100,30,36,31,36,30,131,31,147,31,26,31,26,30,51,31,26,31,58,31,58,30,58,29,174,31,191,31,176,31,7,31,171,31,180,31,134,31,135,31,207,31,230,31,253,31,159,31,159,30,159,29,60,31,241,31,114,31,114,30,10,31,166,31,221,31,221,30,28,31,205,31,221,31,16,31,16,30,100,31,189,31,7,31,4,31,177,31,99,31,54,31,167,31,167,30,129,31,129,30,212,31,8,31,51,31,89,31,158,31,158,30,181,31,25,31,25,30,25,29,219,31,219,30,207,31,249,31,122,31,31,31,212,31,212,30,210,31,241,31,212,31,13,31,29,31,209,31,232,31,232,30,254,31,254,30,57,31,218,31,245,31,245,31,146,31,181,31,56,31,168,31,168,30,191,31,19,31,149,31,43,31,65,31,235,31,82,31,121,31,121,30,119,31,119,30,201,31,34,31,9,31,250,31,24,31,9,31,9,30,5,31,5,30,129,31,151,31,64,31,104,31,236,31,236,30,64,31,64,30,43,31,34,31,253,31,253,30,253,29,253,28,253,27,130,31,220,31,89,31,184,31,217,31,83,31,202,31,140,31,194,31,194,30,194,29,194,28,210,31,235,31,235,30,235,29,27,31,201,31,201,30,245,31,44,31,49,31,49,30,49,29,33,31,99,31,252,31,188,31,181,31,181,30,50,31,171,31,148,31,30,31,138,31,108,31,237,31,155,31,183,31,183,30,79,31,85,31,85,30,85,29);

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

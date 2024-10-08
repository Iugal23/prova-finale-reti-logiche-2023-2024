-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_444 is
end project_tb_444;

architecture project_tb_arch_444 of project_tb_444 is
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

constant SCENARIO_LENGTH : integer := 567;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (133,0,231,0,92,0,193,0,86,0,242,0,1,0,0,0,109,0,118,0,15,0,102,0,5,0,96,0,203,0,51,0,17,0,136,0,113,0,59,0,178,0,197,0,159,0,169,0,0,0,2,0,0,0,0,0,169,0,122,0,0,0,72,0,134,0,168,0,22,0,100,0,0,0,36,0,0,0,0,0,0,0,84,0,13,0,144,0,179,0,193,0,247,0,0,0,120,0,53,0,142,0,20,0,185,0,98,0,66,0,244,0,248,0,176,0,187,0,0,0,0,0,14,0,210,0,225,0,142,0,100,0,170,0,91,0,73,0,159,0,70,0,151,0,50,0,54,0,88,0,28,0,212,0,213,0,204,0,98,0,138,0,139,0,0,0,232,0,0,0,104,0,50,0,27,0,73,0,103,0,178,0,241,0,0,0,234,0,130,0,137,0,86,0,194,0,251,0,59,0,0,0,0,0,21,0,26,0,135,0,0,0,0,0,15,0,28,0,45,0,110,0,0,0,232,0,148,0,137,0,147,0,4,0,0,0,0,0,142,0,158,0,186,0,148,0,178,0,18,0,179,0,231,0,107,0,100,0,156,0,226,0,101,0,109,0,217,0,13,0,17,0,85,0,252,0,136,0,0,0,66,0,0,0,144,0,36,0,0,0,140,0,0,0,32,0,0,0,142,0,130,0,210,0,0,0,196,0,4,0,0,0,146,0,0,0,133,0,190,0,137,0,181,0,164,0,185,0,0,0,0,0,0,0,6,0,209,0,70,0,0,0,31,0,139,0,221,0,100,0,171,0,153,0,87,0,0,0,186,0,0,0,205,0,0,0,210,0,188,0,110,0,0,0,126,0,203,0,209,0,108,0,0,0,255,0,138,0,88,0,24,0,58,0,195,0,0,0,100,0,237,0,92,0,48,0,161,0,227,0,158,0,0,0,0,0,149,0,222,0,200,0,59,0,4,0,28,0,234,0,105,0,77,0,143,0,250,0,139,0,146,0,26,0,44,0,93,0,63,0,108,0,76,0,0,0,23,0,0,0,0,0,1,0,0,0,101,0,7,0,134,0,12,0,2,0,253,0,152,0,102,0,77,0,167,0,187,0,194,0,90,0,0,0,0,0,134,0,0,0,121,0,228,0,47,0,211,0,93,0,133,0,13,0,0,0,206,0,0,0,248,0,173,0,205,0,66,0,0,0,196,0,16,0,110,0,217,0,106,0,111,0,224,0,159,0,31,0,191,0,127,0,62,0,84,0,124,0,0,0,0,0,36,0,0,0,229,0,172,0,240,0,45,0,6,0,212,0,139,0,0,0,0,0,223,0,214,0,59,0,33,0,141,0,233,0,117,0,22,0,106,0,81,0,92,0,153,0,72,0,217,0,33,0,116,0,0,0,190,0,167,0,209,0,141,0,0,0,2,0,57,0,9,0,0,0,82,0,0,0,157,0,217,0,94,0,51,0,0,0,185,0,0,0,156,0,152,0,140,0,231,0,78,0,69,0,0,0,122,0,83,0,116,0,138,0,0,0,173,0,212,0,167,0,57,0,32,0,160,0,160,0,166,0,101,0,71,0,226,0,14,0,0,0,135,0,251,0,60,0,208,0,0,0,146,0,93,0,27,0,0,0,249,0,219,0,6,0,115,0,156,0,0,0,0,0,35,0,0,0,197,0,187,0,175,0,79,0,228,0,0,0,129,0,43,0,103,0,138,0,146,0,122,0,0,0,21,0,81,0,178,0,0,0,151,0,111,0,23,0,0,0,42,0,62,0,114,0,124,0,114,0,245,0,46,0,234,0,155,0,23,0,244,0,106,0,199,0,2,0,81,0,208,0,254,0,255,0,98,0,102,0,176,0,18,0,60,0,59,0,242,0,203,0,141,0,0,0,125,0,206,0,116,0,0,0,167,0,200,0,253,0,205,0,53,0,214,0,0,0,0,0,12,0,0,0,137,0,11,0,38,0,0,0,0,0,243,0,0,0,224,0,143,0,0,0,106,0,235,0,0,0,179,0,245,0,83,0,227,0,80,0,49,0,59,0,85,0,98,0,154,0,54,0,44,0,29,0,19,0,70,0,234,0,83,0,7,0,119,0,28,0,144,0,186,0,59,0,215,0,34,0,0,0,70,0,199,0,0,0,121,0,4,0,142,0,104,0,75,0,240,0,5,0,255,0,204,0,239,0,40,0,255,0,236,0,0,0,220,0,148,0,124,0,29,0,0,0,221,0,0,0,43,0,56,0,162,0,214,0,132,0,0,0,0,0,160,0,196,0,0,0,113,0,68,0,225,0,162,0,36,0,230,0,68,0,0,0,207,0,225,0,224,0,73,0,130,0,163,0,181,0,220,0,231,0,230,0,112,0,42,0,198,0,84,0,0,0,28,0,0,0,66,0,180,0,0,0,103,0,180,0,80,0,128,0,33,0,179,0,104,0,212,0,196,0,127,0,182,0,86,0,189,0,103,0,0,0,10,0,72,0,121,0,115,0,61,0,77,0,128,0,198,0,85,0,147,0,68,0,204,0,28,0,0,0,137,0,231,0,81,0,206,0);
signal scenario_full  : scenario_type := (133,31,231,31,92,31,193,31,86,31,242,31,1,31,1,30,109,31,118,31,15,31,102,31,5,31,96,31,203,31,51,31,17,31,136,31,113,31,59,31,178,31,197,31,159,31,169,31,169,30,2,31,2,30,2,29,169,31,122,31,122,30,72,31,134,31,168,31,22,31,100,31,100,30,36,31,36,30,36,29,36,28,84,31,13,31,144,31,179,31,193,31,247,31,247,30,120,31,53,31,142,31,20,31,185,31,98,31,66,31,244,31,248,31,176,31,187,31,187,30,187,29,14,31,210,31,225,31,142,31,100,31,170,31,91,31,73,31,159,31,70,31,151,31,50,31,54,31,88,31,28,31,212,31,213,31,204,31,98,31,138,31,139,31,139,30,232,31,232,30,104,31,50,31,27,31,73,31,103,31,178,31,241,31,241,30,234,31,130,31,137,31,86,31,194,31,251,31,59,31,59,30,59,29,21,31,26,31,135,31,135,30,135,29,15,31,28,31,45,31,110,31,110,30,232,31,148,31,137,31,147,31,4,31,4,30,4,29,142,31,158,31,186,31,148,31,178,31,18,31,179,31,231,31,107,31,100,31,156,31,226,31,101,31,109,31,217,31,13,31,17,31,85,31,252,31,136,31,136,30,66,31,66,30,144,31,36,31,36,30,140,31,140,30,32,31,32,30,142,31,130,31,210,31,210,30,196,31,4,31,4,30,146,31,146,30,133,31,190,31,137,31,181,31,164,31,185,31,185,30,185,29,185,28,6,31,209,31,70,31,70,30,31,31,139,31,221,31,100,31,171,31,153,31,87,31,87,30,186,31,186,30,205,31,205,30,210,31,188,31,110,31,110,30,126,31,203,31,209,31,108,31,108,30,255,31,138,31,88,31,24,31,58,31,195,31,195,30,100,31,237,31,92,31,48,31,161,31,227,31,158,31,158,30,158,29,149,31,222,31,200,31,59,31,4,31,28,31,234,31,105,31,77,31,143,31,250,31,139,31,146,31,26,31,44,31,93,31,63,31,108,31,76,31,76,30,23,31,23,30,23,29,1,31,1,30,101,31,7,31,134,31,12,31,2,31,253,31,152,31,102,31,77,31,167,31,187,31,194,31,90,31,90,30,90,29,134,31,134,30,121,31,228,31,47,31,211,31,93,31,133,31,13,31,13,30,206,31,206,30,248,31,173,31,205,31,66,31,66,30,196,31,16,31,110,31,217,31,106,31,111,31,224,31,159,31,31,31,191,31,127,31,62,31,84,31,124,31,124,30,124,29,36,31,36,30,229,31,172,31,240,31,45,31,6,31,212,31,139,31,139,30,139,29,223,31,214,31,59,31,33,31,141,31,233,31,117,31,22,31,106,31,81,31,92,31,153,31,72,31,217,31,33,31,116,31,116,30,190,31,167,31,209,31,141,31,141,30,2,31,57,31,9,31,9,30,82,31,82,30,157,31,217,31,94,31,51,31,51,30,185,31,185,30,156,31,152,31,140,31,231,31,78,31,69,31,69,30,122,31,83,31,116,31,138,31,138,30,173,31,212,31,167,31,57,31,32,31,160,31,160,31,166,31,101,31,71,31,226,31,14,31,14,30,135,31,251,31,60,31,208,31,208,30,146,31,93,31,27,31,27,30,249,31,219,31,6,31,115,31,156,31,156,30,156,29,35,31,35,30,197,31,187,31,175,31,79,31,228,31,228,30,129,31,43,31,103,31,138,31,146,31,122,31,122,30,21,31,81,31,178,31,178,30,151,31,111,31,23,31,23,30,42,31,62,31,114,31,124,31,114,31,245,31,46,31,234,31,155,31,23,31,244,31,106,31,199,31,2,31,81,31,208,31,254,31,255,31,98,31,102,31,176,31,18,31,60,31,59,31,242,31,203,31,141,31,141,30,125,31,206,31,116,31,116,30,167,31,200,31,253,31,205,31,53,31,214,31,214,30,214,29,12,31,12,30,137,31,11,31,38,31,38,30,38,29,243,31,243,30,224,31,143,31,143,30,106,31,235,31,235,30,179,31,245,31,83,31,227,31,80,31,49,31,59,31,85,31,98,31,154,31,54,31,44,31,29,31,19,31,70,31,234,31,83,31,7,31,119,31,28,31,144,31,186,31,59,31,215,31,34,31,34,30,70,31,199,31,199,30,121,31,4,31,142,31,104,31,75,31,240,31,5,31,255,31,204,31,239,31,40,31,255,31,236,31,236,30,220,31,148,31,124,31,29,31,29,30,221,31,221,30,43,31,56,31,162,31,214,31,132,31,132,30,132,29,160,31,196,31,196,30,113,31,68,31,225,31,162,31,36,31,230,31,68,31,68,30,207,31,225,31,224,31,73,31,130,31,163,31,181,31,220,31,231,31,230,31,112,31,42,31,198,31,84,31,84,30,28,31,28,30,66,31,180,31,180,30,103,31,180,31,80,31,128,31,33,31,179,31,104,31,212,31,196,31,127,31,182,31,86,31,189,31,103,31,103,30,10,31,72,31,121,31,115,31,61,31,77,31,128,31,198,31,85,31,147,31,68,31,204,31,28,31,28,30,137,31,231,31,81,31,206,31);

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

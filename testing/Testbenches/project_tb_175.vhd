-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_175 is
end project_tb_175;

architecture project_tb_arch_175 of project_tb_175 is
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

constant SCENARIO_LENGTH : integer := 611;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,40,0,0,0,3,0,0,0,76,0,8,0,186,0,0,0,148,0,94,0,59,0,75,0,202,0,0,0,75,0,102,0,175,0,226,0,53,0,237,0,214,0,0,0,0,0,166,0,0,0,85,0,0,0,0,0,234,0,29,0,227,0,149,0,17,0,0,0,246,0,206,0,52,0,122,0,71,0,191,0,183,0,185,0,176,0,0,0,179,0,95,0,205,0,192,0,0,0,0,0,70,0,0,0,248,0,15,0,0,0,173,0,125,0,19,0,87,0,51,0,219,0,86,0,231,0,0,0,42,0,0,0,36,0,206,0,66,0,0,0,128,0,0,0,120,0,108,0,0,0,186,0,0,0,170,0,30,0,199,0,25,0,248,0,126,0,127,0,176,0,131,0,75,0,225,0,196,0,236,0,61,0,63,0,253,0,154,0,0,0,0,0,102,0,168,0,213,0,0,0,146,0,217,0,15,0,69,0,162,0,84,0,47,0,0,0,253,0,173,0,0,0,255,0,182,0,0,0,237,0,0,0,143,0,159,0,0,0,254,0,0,0,33,0,229,0,243,0,190,0,34,0,163,0,121,0,98,0,59,0,10,0,91,0,159,0,55,0,241,0,146,0,0,0,242,0,2,0,153,0,55,0,215,0,228,0,72,0,0,0,113,0,205,0,235,0,79,0,135,0,114,0,252,0,77,0,0,0,106,0,204,0,21,0,0,0,152,0,121,0,47,0,160,0,127,0,246,0,255,0,111,0,237,0,0,0,0,0,141,0,0,0,204,0,0,0,18,0,77,0,236,0,149,0,0,0,161,0,218,0,201,0,68,0,222,0,66,0,0,0,118,0,119,0,19,0,0,0,196,0,0,0,22,0,0,0,0,0,87,0,30,0,40,0,190,0,65,0,53,0,10,0,102,0,39,0,3,0,134,0,35,0,0,0,8,0,0,0,68,0,28,0,1,0,84,0,154,0,224,0,101,0,29,0,0,0,224,0,0,0,171,0,39,0,204,0,222,0,205,0,4,0,53,0,67,0,189,0,0,0,203,0,0,0,13,0,165,0,151,0,0,0,160,0,4,0,0,0,38,0,0,0,176,0,125,0,0,0,0,0,0,0,249,0,210,0,243,0,86,0,31,0,152,0,153,0,119,0,204,0,28,0,237,0,185,0,242,0,0,0,82,0,183,0,83,0,0,0,0,0,246,0,6,0,222,0,189,0,248,0,62,0,146,0,150,0,0,0,252,0,0,0,0,0,198,0,30,0,0,0,51,0,160,0,0,0,135,0,0,0,128,0,193,0,139,0,83,0,237,0,220,0,91,0,69,0,0,0,193,0,242,0,81,0,13,0,37,0,0,0,70,0,13,0,107,0,98,0,32,0,0,0,80,0,81,0,206,0,182,0,122,0,162,0,235,0,106,0,89,0,130,0,107,0,71,0,66,0,121,0,0,0,64,0,248,0,178,0,0,0,136,0,0,0,0,0,75,0,80,0,28,0,133,0,41,0,2,0,236,0,122,0,136,0,146,0,219,0,253,0,238,0,82,0,53,0,209,0,12,0,195,0,0,0,40,0,234,0,176,0,169,0,13,0,0,0,197,0,0,0,51,0,5,0,8,0,0,0,132,0,76,0,0,0,151,0,225,0,88,0,88,0,169,0,0,0,31,0,227,0,157,0,50,0,0,0,0,0,136,0,208,0,233,0,0,0,0,0,243,0,0,0,161,0,0,0,0,0,0,0,188,0,198,0,176,0,0,0,233,0,146,0,0,0,245,0,212,0,34,0,158,0,151,0,77,0,48,0,174,0,161,0,54,0,0,0,0,0,2,0,222,0,73,0,98,0,89,0,188,0,0,0,142,0,0,0,69,0,148,0,180,0,153,0,33,0,23,0,53,0,0,0,229,0,161,0,0,0,0,0,208,0,164,0,125,0,0,0,92,0,226,0,90,0,30,0,192,0,52,0,0,0,0,0,0,0,191,0,175,0,10,0,181,0,0,0,26,0,244,0,167,0,221,0,158,0,252,0,117,0,39,0,0,0,132,0,140,0,149,0,0,0,189,0,177,0,13,0,0,0,153,0,70,0,0,0,6,0,159,0,203,0,0,0,121,0,54,0,240,0,52,0,46,0,183,0,89,0,106,0,213,0,40,0,80,0,6,0,169,0,0,0,156,0,0,0,0,0,47,0,0,0,64,0,110,0,0,0,39,0,198,0,207,0,68,0,132,0,34,0,0,0,0,0,28,0,0,0,0,0,0,0,173,0,161,0,54,0,214,0,78,0,130,0,240,0,218,0,0,0,209,0,250,0,0,0,17,0,73,0,62,0,117,0,0,0,247,0,154,0,105,0,0,0,217,0,90,0,186,0,130,0,243,0,0,0,45,0,0,0,128,0,163,0,141,0,174,0,68,0,72,0,234,0,37,0,152,0,29,0,0,0,1,0,98,0,98,0,90,0,116,0,214,0,68,0,177,0,248,0,115,0,0,0,240,0,25,0,20,0,214,0,0,0,11,0,35,0,141,0,157,0,252,0,136,0,0,0,214,0,0,0,182,0,0,0,236,0,229,0,248,0,150,0,137,0,0,0,244,0,69,0,0,0,0,0,0,0,154,0,91,0,94,0,182,0,0,0,91,0,114,0,238,0,150,0,82,0,168,0,130,0,213,0,7,0,111,0,0,0,156,0,184,0,114,0,85,0,0,0,187,0,3,0,0,0,59,0,33,0,200,0,177,0,219,0,0,0,252,0);
signal scenario_full  : scenario_type := (0,0,40,31,40,30,3,31,3,30,76,31,8,31,186,31,186,30,148,31,94,31,59,31,75,31,202,31,202,30,75,31,102,31,175,31,226,31,53,31,237,31,214,31,214,30,214,29,166,31,166,30,85,31,85,30,85,29,234,31,29,31,227,31,149,31,17,31,17,30,246,31,206,31,52,31,122,31,71,31,191,31,183,31,185,31,176,31,176,30,179,31,95,31,205,31,192,31,192,30,192,29,70,31,70,30,248,31,15,31,15,30,173,31,125,31,19,31,87,31,51,31,219,31,86,31,231,31,231,30,42,31,42,30,36,31,206,31,66,31,66,30,128,31,128,30,120,31,108,31,108,30,186,31,186,30,170,31,30,31,199,31,25,31,248,31,126,31,127,31,176,31,131,31,75,31,225,31,196,31,236,31,61,31,63,31,253,31,154,31,154,30,154,29,102,31,168,31,213,31,213,30,146,31,217,31,15,31,69,31,162,31,84,31,47,31,47,30,253,31,173,31,173,30,255,31,182,31,182,30,237,31,237,30,143,31,159,31,159,30,254,31,254,30,33,31,229,31,243,31,190,31,34,31,163,31,121,31,98,31,59,31,10,31,91,31,159,31,55,31,241,31,146,31,146,30,242,31,2,31,153,31,55,31,215,31,228,31,72,31,72,30,113,31,205,31,235,31,79,31,135,31,114,31,252,31,77,31,77,30,106,31,204,31,21,31,21,30,152,31,121,31,47,31,160,31,127,31,246,31,255,31,111,31,237,31,237,30,237,29,141,31,141,30,204,31,204,30,18,31,77,31,236,31,149,31,149,30,161,31,218,31,201,31,68,31,222,31,66,31,66,30,118,31,119,31,19,31,19,30,196,31,196,30,22,31,22,30,22,29,87,31,30,31,40,31,190,31,65,31,53,31,10,31,102,31,39,31,3,31,134,31,35,31,35,30,8,31,8,30,68,31,28,31,1,31,84,31,154,31,224,31,101,31,29,31,29,30,224,31,224,30,171,31,39,31,204,31,222,31,205,31,4,31,53,31,67,31,189,31,189,30,203,31,203,30,13,31,165,31,151,31,151,30,160,31,4,31,4,30,38,31,38,30,176,31,125,31,125,30,125,29,125,28,249,31,210,31,243,31,86,31,31,31,152,31,153,31,119,31,204,31,28,31,237,31,185,31,242,31,242,30,82,31,183,31,83,31,83,30,83,29,246,31,6,31,222,31,189,31,248,31,62,31,146,31,150,31,150,30,252,31,252,30,252,29,198,31,30,31,30,30,51,31,160,31,160,30,135,31,135,30,128,31,193,31,139,31,83,31,237,31,220,31,91,31,69,31,69,30,193,31,242,31,81,31,13,31,37,31,37,30,70,31,13,31,107,31,98,31,32,31,32,30,80,31,81,31,206,31,182,31,122,31,162,31,235,31,106,31,89,31,130,31,107,31,71,31,66,31,121,31,121,30,64,31,248,31,178,31,178,30,136,31,136,30,136,29,75,31,80,31,28,31,133,31,41,31,2,31,236,31,122,31,136,31,146,31,219,31,253,31,238,31,82,31,53,31,209,31,12,31,195,31,195,30,40,31,234,31,176,31,169,31,13,31,13,30,197,31,197,30,51,31,5,31,8,31,8,30,132,31,76,31,76,30,151,31,225,31,88,31,88,31,169,31,169,30,31,31,227,31,157,31,50,31,50,30,50,29,136,31,208,31,233,31,233,30,233,29,243,31,243,30,161,31,161,30,161,29,161,28,188,31,198,31,176,31,176,30,233,31,146,31,146,30,245,31,212,31,34,31,158,31,151,31,77,31,48,31,174,31,161,31,54,31,54,30,54,29,2,31,222,31,73,31,98,31,89,31,188,31,188,30,142,31,142,30,69,31,148,31,180,31,153,31,33,31,23,31,53,31,53,30,229,31,161,31,161,30,161,29,208,31,164,31,125,31,125,30,92,31,226,31,90,31,30,31,192,31,52,31,52,30,52,29,52,28,191,31,175,31,10,31,181,31,181,30,26,31,244,31,167,31,221,31,158,31,252,31,117,31,39,31,39,30,132,31,140,31,149,31,149,30,189,31,177,31,13,31,13,30,153,31,70,31,70,30,6,31,159,31,203,31,203,30,121,31,54,31,240,31,52,31,46,31,183,31,89,31,106,31,213,31,40,31,80,31,6,31,169,31,169,30,156,31,156,30,156,29,47,31,47,30,64,31,110,31,110,30,39,31,198,31,207,31,68,31,132,31,34,31,34,30,34,29,28,31,28,30,28,29,28,28,173,31,161,31,54,31,214,31,78,31,130,31,240,31,218,31,218,30,209,31,250,31,250,30,17,31,73,31,62,31,117,31,117,30,247,31,154,31,105,31,105,30,217,31,90,31,186,31,130,31,243,31,243,30,45,31,45,30,128,31,163,31,141,31,174,31,68,31,72,31,234,31,37,31,152,31,29,31,29,30,1,31,98,31,98,31,90,31,116,31,214,31,68,31,177,31,248,31,115,31,115,30,240,31,25,31,20,31,214,31,214,30,11,31,35,31,141,31,157,31,252,31,136,31,136,30,214,31,214,30,182,31,182,30,236,31,229,31,248,31,150,31,137,31,137,30,244,31,69,31,69,30,69,29,69,28,154,31,91,31,94,31,182,31,182,30,91,31,114,31,238,31,150,31,82,31,168,31,130,31,213,31,7,31,111,31,111,30,156,31,184,31,114,31,85,31,85,30,187,31,3,31,3,30,59,31,33,31,200,31,177,31,219,31,219,30,252,31);

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

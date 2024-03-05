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

constant SCENARIO_LENGTH : integer := 475;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (152,0,48,0,27,0,246,0,85,0,134,0,61,0,94,0,186,0,227,0,41,0,209,0,0,0,173,0,0,0,178,0,69,0,199,0,190,0,9,0,247,0,253,0,173,0,191,0,100,0,49,0,0,0,24,0,20,0,0,0,25,0,88,0,178,0,133,0,0,0,0,0,121,0,0,0,119,0,108,0,218,0,251,0,206,0,0,0,53,0,0,0,25,0,236,0,0,0,230,0,0,0,211,0,119,0,255,0,0,0,7,0,104,0,62,0,195,0,195,0,174,0,161,0,38,0,205,0,2,0,173,0,14,0,84,0,171,0,238,0,62,0,195,0,160,0,122,0,103,0,153,0,137,0,130,0,199,0,125,0,90,0,144,0,58,0,129,0,247,0,2,0,116,0,92,0,189,0,248,0,217,0,76,0,103,0,12,0,134,0,53,0,250,0,175,0,59,0,176,0,171,0,21,0,7,0,0,0,215,0,62,0,149,0,88,0,0,0,38,0,224,0,71,0,28,0,131,0,233,0,68,0,20,0,247,0,62,0,12,0,0,0,126,0,151,0,134,0,113,0,245,0,8,0,190,0,131,0,0,0,209,0,189,0,160,0,189,0,100,0,214,0,0,0,250,0,0,0,66,0,100,0,239,0,125,0,0,0,9,0,55,0,204,0,208,0,176,0,0,0,75,0,233,0,137,0,0,0,213,0,190,0,77,0,141,0,37,0,146,0,162,0,152,0,68,0,171,0,44,0,130,0,86,0,196,0,101,0,145,0,0,0,0,0,140,0,50,0,158,0,57,0,0,0,160,0,125,0,78,0,0,0,185,0,0,0,177,0,0,0,157,0,0,0,120,0,0,0,119,0,52,0,89,0,0,0,0,0,52,0,71,0,193,0,145,0,190,0,0,0,250,0,52,0,164,0,89,0,0,0,69,0,162,0,0,0,104,0,197,0,39,0,61,0,128,0,31,0,158,0,236,0,72,0,0,0,1,0,168,0,124,0,100,0,226,0,59,0,226,0,114,0,0,0,224,0,0,0,222,0,212,0,24,0,156,0,14,0,143,0,144,0,133,0,192,0,214,0,56,0,84,0,164,0,51,0,0,0,177,0,66,0,232,0,195,0,0,0,30,0,191,0,199,0,0,0,163,0,78,0,17,0,231,0,186,0,71,0,0,0,169,0,238,0,17,0,4,0,63,0,54,0,185,0,71,0,46,0,213,0,13,0,0,0,0,0,0,0,17,0,162,0,212,0,153,0,14,0,155,0,236,0,31,0,4,0,0,0,131,0,15,0,0,0,253,0,110,0,74,0,58,0,57,0,0,0,208,0,68,0,52,0,19,0,81,0,206,0,0,0,33,0,89,0,39,0,228,0,88,0,90,0,208,0,200,0,212,0,32,0,0,0,87,0,0,0,0,0,0,0,38,0,65,0,126,0,23,0,234,0,36,0,18,0,89,0,66,0,0,0,236,0,193,0,195,0,118,0,220,0,105,0,184,0,197,0,224,0,115,0,170,0,204,0,0,0,47,0,109,0,0,0,224,0,109,0,238,0,0,0,167,0,197,0,77,0,194,0,94,0,49,0,0,0,236,0,192,0,132,0,0,0,8,0,117,0,0,0,0,0,0,0,102,0,0,0,235,0,212,0,167,0,201,0,159,0,82,0,163,0,161,0,39,0,188,0,0,0,0,0,18,0,29,0,66,0,179,0,6,0,67,0,0,0,93,0,100,0,65,0,59,0,0,0,50,0,100,0,242,0,0,0,87,0,12,0,14,0,167,0,92,0,32,0,141,0,20,0,208,0,29,0,25,0,0,0,0,0,172,0,254,0,0,0,205,0,238,0,234,0,103,0,133,0,102,0,188,0,138,0,39,0,164,0,136,0,0,0,94,0,112,0,28,0,3,0,221,0,178,0,178,0,228,0,32,0,2,0,8,0,149,0,182,0,107,0,229,0,187,0,11,0,161,0,16,0,188,0,226,0,171,0,86,0,59,0,211,0,108,0,22,0,105,0,20,0,217,0,30,0,0,0,95,0,0,0,53,0,175,0,72,0,227,0,66,0,88,0,84,0,0,0,156,0,55,0,103,0,165,0,166,0,91,0,253,0,51,0,0,0,41,0,6,0,32,0,78,0,189,0);
signal scenario_full  : scenario_type := (152,31,48,31,27,31,246,31,85,31,134,31,61,31,94,31,186,31,227,31,41,31,209,31,209,30,173,31,173,30,178,31,69,31,199,31,190,31,9,31,247,31,253,31,173,31,191,31,100,31,49,31,49,30,24,31,20,31,20,30,25,31,88,31,178,31,133,31,133,30,133,29,121,31,121,30,119,31,108,31,218,31,251,31,206,31,206,30,53,31,53,30,25,31,236,31,236,30,230,31,230,30,211,31,119,31,255,31,255,30,7,31,104,31,62,31,195,31,195,31,174,31,161,31,38,31,205,31,2,31,173,31,14,31,84,31,171,31,238,31,62,31,195,31,160,31,122,31,103,31,153,31,137,31,130,31,199,31,125,31,90,31,144,31,58,31,129,31,247,31,2,31,116,31,92,31,189,31,248,31,217,31,76,31,103,31,12,31,134,31,53,31,250,31,175,31,59,31,176,31,171,31,21,31,7,31,7,30,215,31,62,31,149,31,88,31,88,30,38,31,224,31,71,31,28,31,131,31,233,31,68,31,20,31,247,31,62,31,12,31,12,30,126,31,151,31,134,31,113,31,245,31,8,31,190,31,131,31,131,30,209,31,189,31,160,31,189,31,100,31,214,31,214,30,250,31,250,30,66,31,100,31,239,31,125,31,125,30,9,31,55,31,204,31,208,31,176,31,176,30,75,31,233,31,137,31,137,30,213,31,190,31,77,31,141,31,37,31,146,31,162,31,152,31,68,31,171,31,44,31,130,31,86,31,196,31,101,31,145,31,145,30,145,29,140,31,50,31,158,31,57,31,57,30,160,31,125,31,78,31,78,30,185,31,185,30,177,31,177,30,157,31,157,30,120,31,120,30,119,31,52,31,89,31,89,30,89,29,52,31,71,31,193,31,145,31,190,31,190,30,250,31,52,31,164,31,89,31,89,30,69,31,162,31,162,30,104,31,197,31,39,31,61,31,128,31,31,31,158,31,236,31,72,31,72,30,1,31,168,31,124,31,100,31,226,31,59,31,226,31,114,31,114,30,224,31,224,30,222,31,212,31,24,31,156,31,14,31,143,31,144,31,133,31,192,31,214,31,56,31,84,31,164,31,51,31,51,30,177,31,66,31,232,31,195,31,195,30,30,31,191,31,199,31,199,30,163,31,78,31,17,31,231,31,186,31,71,31,71,30,169,31,238,31,17,31,4,31,63,31,54,31,185,31,71,31,46,31,213,31,13,31,13,30,13,29,13,28,17,31,162,31,212,31,153,31,14,31,155,31,236,31,31,31,4,31,4,30,131,31,15,31,15,30,253,31,110,31,74,31,58,31,57,31,57,30,208,31,68,31,52,31,19,31,81,31,206,31,206,30,33,31,89,31,39,31,228,31,88,31,90,31,208,31,200,31,212,31,32,31,32,30,87,31,87,30,87,29,87,28,38,31,65,31,126,31,23,31,234,31,36,31,18,31,89,31,66,31,66,30,236,31,193,31,195,31,118,31,220,31,105,31,184,31,197,31,224,31,115,31,170,31,204,31,204,30,47,31,109,31,109,30,224,31,109,31,238,31,238,30,167,31,197,31,77,31,194,31,94,31,49,31,49,30,236,31,192,31,132,31,132,30,8,31,117,31,117,30,117,29,117,28,102,31,102,30,235,31,212,31,167,31,201,31,159,31,82,31,163,31,161,31,39,31,188,31,188,30,188,29,18,31,29,31,66,31,179,31,6,31,67,31,67,30,93,31,100,31,65,31,59,31,59,30,50,31,100,31,242,31,242,30,87,31,12,31,14,31,167,31,92,31,32,31,141,31,20,31,208,31,29,31,25,31,25,30,25,29,172,31,254,31,254,30,205,31,238,31,234,31,103,31,133,31,102,31,188,31,138,31,39,31,164,31,136,31,136,30,94,31,112,31,28,31,3,31,221,31,178,31,178,31,228,31,32,31,2,31,8,31,149,31,182,31,107,31,229,31,187,31,11,31,161,31,16,31,188,31,226,31,171,31,86,31,59,31,211,31,108,31,22,31,105,31,20,31,217,31,30,31,30,30,95,31,95,30,53,31,175,31,72,31,227,31,66,31,88,31,84,31,84,30,156,31,55,31,103,31,165,31,166,31,91,31,253,31,51,31,51,30,41,31,6,31,32,31,78,31,189,31);

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

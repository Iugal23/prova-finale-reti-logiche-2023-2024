-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_755 is
end project_tb_755;

architecture project_tb_arch_755 of project_tb_755 is
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

constant SCENARIO_LENGTH : integer := 568;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (200,0,57,0,177,0,0,0,6,0,7,0,193,0,251,0,111,0,0,0,114,0,168,0,208,0,86,0,51,0,68,0,0,0,255,0,117,0,55,0,92,0,42,0,138,0,106,0,55,0,230,0,210,0,207,0,21,0,0,0,82,0,45,0,0,0,102,0,0,0,16,0,0,0,99,0,242,0,199,0,0,0,24,0,88,0,119,0,170,0,0,0,28,0,43,0,203,0,43,0,80,0,44,0,12,0,118,0,251,0,92,0,206,0,189,0,113,0,20,0,215,0,1,0,45,0,233,0,0,0,9,0,0,0,0,0,62,0,0,0,195,0,74,0,204,0,210,0,235,0,120,0,159,0,188,0,45,0,216,0,25,0,0,0,7,0,161,0,165,0,237,0,0,0,211,0,0,0,155,0,176,0,0,0,208,0,73,0,250,0,54,0,133,0,0,0,163,0,181,0,54,0,0,0,15,0,55,0,210,0,51,0,0,0,24,0,1,0,40,0,7,0,16,0,199,0,43,0,227,0,0,0,180,0,140,0,0,0,91,0,230,0,75,0,0,0,0,0,170,0,15,0,47,0,65,0,165,0,126,0,222,0,198,0,12,0,108,0,178,0,123,0,101,0,148,0,98,0,71,0,252,0,93,0,167,0,86,0,20,0,112,0,149,0,122,0,36,0,83,0,92,0,234,0,214,0,196,0,105,0,3,0,189,0,27,0,26,0,0,0,0,0,204,0,165,0,0,0,0,0,240,0,0,0,209,0,204,0,0,0,172,0,0,0,10,0,57,0,44,0,128,0,199,0,0,0,5,0,227,0,138,0,143,0,27,0,0,0,248,0,202,0,152,0,0,0,196,0,69,0,55,0,0,0,221,0,0,0,240,0,0,0,92,0,38,0,165,0,139,0,129,0,178,0,89,0,25,0,126,0,61,0,179,0,236,0,96,0,175,0,55,0,0,0,95,0,75,0,251,0,131,0,9,0,146,0,28,0,120,0,109,0,3,0,179,0,67,0,196,0,232,0,144,0,111,0,137,0,33,0,208,0,83,0,64,0,2,0,252,0,99,0,210,0,0,0,108,0,193,0,118,0,0,0,41,0,48,0,213,0,132,0,0,0,0,0,0,0,0,0,0,0,254,0,0,0,197,0,154,0,115,0,0,0,234,0,86,0,202,0,135,0,200,0,16,0,131,0,10,0,222,0,41,0,19,0,68,0,109,0,43,0,188,0,83,0,135,0,93,0,182,0,0,0,6,0,79,0,0,0,178,0,255,0,0,0,149,0,52,0,116,0,86,0,0,0,0,0,158,0,34,0,104,0,162,0,175,0,13,0,65,0,0,0,55,0,139,0,244,0,73,0,22,0,16,0,193,0,178,0,127,0,103,0,47,0,34,0,0,0,117,0,163,0,198,0,0,0,239,0,170,0,70,0,95,0,209,0,39,0,190,0,119,0,58,0,30,0,243,0,229,0,216,0,8,0,94,0,86,0,3,0,97,0,0,0,0,0,118,0,124,0,16,0,0,0,0,0,181,0,248,0,88,0,82,0,153,0,147,0,134,0,64,0,51,0,109,0,179,0,66,0,106,0,59,0,138,0,32,0,47,0,239,0,200,0,102,0,30,0,0,0,66,0,0,0,147,0,77,0,71,0,170,0,0,0,107,0,110,0,126,0,212,0,0,0,203,0,18,0,9,0,193,0,62,0,255,0,0,0,0,0,201,0,147,0,243,0,15,0,220,0,46,0,98,0,174,0,41,0,0,0,225,0,182,0,62,0,0,0,34,0,26,0,65,0,44,0,102,0,144,0,133,0,63,0,102,0,0,0,80,0,96,0,0,0,34,0,227,0,149,0,194,0,89,0,124,0,0,0,58,0,82,0,253,0,8,0,46,0,164,0,0,0,119,0,0,0,152,0,203,0,10,0,226,0,101,0,172,0,43,0,215,0,90,0,202,0,16,0,141,0,237,0,73,0,27,0,70,0,88,0,124,0,66,0,62,0,214,0,225,0,0,0,114,0,212,0,251,0,139,0,254,0,196,0,0,0,160,0,0,0,94,0,93,0,111,0,167,0,23,0,79,0,215,0,49,0,185,0,218,0,161,0,223,0,46,0,204,0,144,0,83,0,96,0,245,0,222,0,168,0,2,0,24,0,13,0,128,0,165,0,0,0,0,0,0,0,46,0,209,0,11,0,108,0,109,0,68,0,121,0,0,0,21,0,48,0,0,0,93,0,199,0,42,0,54,0,142,0,135,0,0,0,0,0,97,0,168,0,4,0,34,0,128,0,202,0,77,0,19,0,95,0,7,0,22,0,132,0,230,0,238,0,0,0,34,0,147,0,173,0,0,0,0,0,18,0,200,0,65,0,100,0,181,0,13,0,223,0,0,0,32,0,255,0,185,0,0,0,20,0,106,0,0,0,81,0,90,0,32,0,250,0,0,0,100,0,136,0,0,0,84,0,62,0,15,0,244,0,193,0,231,0,57,0,0,0,24,0,106,0,0,0,218,0,0,0,7,0,152,0,57,0,20,0,251,0,45,0,229,0,79,0,0,0);
signal scenario_full  : scenario_type := (200,31,57,31,177,31,177,30,6,31,7,31,193,31,251,31,111,31,111,30,114,31,168,31,208,31,86,31,51,31,68,31,68,30,255,31,117,31,55,31,92,31,42,31,138,31,106,31,55,31,230,31,210,31,207,31,21,31,21,30,82,31,45,31,45,30,102,31,102,30,16,31,16,30,99,31,242,31,199,31,199,30,24,31,88,31,119,31,170,31,170,30,28,31,43,31,203,31,43,31,80,31,44,31,12,31,118,31,251,31,92,31,206,31,189,31,113,31,20,31,215,31,1,31,45,31,233,31,233,30,9,31,9,30,9,29,62,31,62,30,195,31,74,31,204,31,210,31,235,31,120,31,159,31,188,31,45,31,216,31,25,31,25,30,7,31,161,31,165,31,237,31,237,30,211,31,211,30,155,31,176,31,176,30,208,31,73,31,250,31,54,31,133,31,133,30,163,31,181,31,54,31,54,30,15,31,55,31,210,31,51,31,51,30,24,31,1,31,40,31,7,31,16,31,199,31,43,31,227,31,227,30,180,31,140,31,140,30,91,31,230,31,75,31,75,30,75,29,170,31,15,31,47,31,65,31,165,31,126,31,222,31,198,31,12,31,108,31,178,31,123,31,101,31,148,31,98,31,71,31,252,31,93,31,167,31,86,31,20,31,112,31,149,31,122,31,36,31,83,31,92,31,234,31,214,31,196,31,105,31,3,31,189,31,27,31,26,31,26,30,26,29,204,31,165,31,165,30,165,29,240,31,240,30,209,31,204,31,204,30,172,31,172,30,10,31,57,31,44,31,128,31,199,31,199,30,5,31,227,31,138,31,143,31,27,31,27,30,248,31,202,31,152,31,152,30,196,31,69,31,55,31,55,30,221,31,221,30,240,31,240,30,92,31,38,31,165,31,139,31,129,31,178,31,89,31,25,31,126,31,61,31,179,31,236,31,96,31,175,31,55,31,55,30,95,31,75,31,251,31,131,31,9,31,146,31,28,31,120,31,109,31,3,31,179,31,67,31,196,31,232,31,144,31,111,31,137,31,33,31,208,31,83,31,64,31,2,31,252,31,99,31,210,31,210,30,108,31,193,31,118,31,118,30,41,31,48,31,213,31,132,31,132,30,132,29,132,28,132,27,132,26,254,31,254,30,197,31,154,31,115,31,115,30,234,31,86,31,202,31,135,31,200,31,16,31,131,31,10,31,222,31,41,31,19,31,68,31,109,31,43,31,188,31,83,31,135,31,93,31,182,31,182,30,6,31,79,31,79,30,178,31,255,31,255,30,149,31,52,31,116,31,86,31,86,30,86,29,158,31,34,31,104,31,162,31,175,31,13,31,65,31,65,30,55,31,139,31,244,31,73,31,22,31,16,31,193,31,178,31,127,31,103,31,47,31,34,31,34,30,117,31,163,31,198,31,198,30,239,31,170,31,70,31,95,31,209,31,39,31,190,31,119,31,58,31,30,31,243,31,229,31,216,31,8,31,94,31,86,31,3,31,97,31,97,30,97,29,118,31,124,31,16,31,16,30,16,29,181,31,248,31,88,31,82,31,153,31,147,31,134,31,64,31,51,31,109,31,179,31,66,31,106,31,59,31,138,31,32,31,47,31,239,31,200,31,102,31,30,31,30,30,66,31,66,30,147,31,77,31,71,31,170,31,170,30,107,31,110,31,126,31,212,31,212,30,203,31,18,31,9,31,193,31,62,31,255,31,255,30,255,29,201,31,147,31,243,31,15,31,220,31,46,31,98,31,174,31,41,31,41,30,225,31,182,31,62,31,62,30,34,31,26,31,65,31,44,31,102,31,144,31,133,31,63,31,102,31,102,30,80,31,96,31,96,30,34,31,227,31,149,31,194,31,89,31,124,31,124,30,58,31,82,31,253,31,8,31,46,31,164,31,164,30,119,31,119,30,152,31,203,31,10,31,226,31,101,31,172,31,43,31,215,31,90,31,202,31,16,31,141,31,237,31,73,31,27,31,70,31,88,31,124,31,66,31,62,31,214,31,225,31,225,30,114,31,212,31,251,31,139,31,254,31,196,31,196,30,160,31,160,30,94,31,93,31,111,31,167,31,23,31,79,31,215,31,49,31,185,31,218,31,161,31,223,31,46,31,204,31,144,31,83,31,96,31,245,31,222,31,168,31,2,31,24,31,13,31,128,31,165,31,165,30,165,29,165,28,46,31,209,31,11,31,108,31,109,31,68,31,121,31,121,30,21,31,48,31,48,30,93,31,199,31,42,31,54,31,142,31,135,31,135,30,135,29,97,31,168,31,4,31,34,31,128,31,202,31,77,31,19,31,95,31,7,31,22,31,132,31,230,31,238,31,238,30,34,31,147,31,173,31,173,30,173,29,18,31,200,31,65,31,100,31,181,31,13,31,223,31,223,30,32,31,255,31,185,31,185,30,20,31,106,31,106,30,81,31,90,31,32,31,250,31,250,30,100,31,136,31,136,30,84,31,62,31,15,31,244,31,193,31,231,31,57,31,57,30,24,31,106,31,106,30,218,31,218,30,7,31,152,31,57,31,20,31,251,31,45,31,229,31,79,31,79,30);

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

-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_166 is
end project_tb_166;

architecture project_tb_arch_166 of project_tb_166 is
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

constant SCENARIO_LENGTH : integer := 550;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (132,0,186,0,197,0,19,0,0,0,98,0,41,0,140,0,178,0,0,0,67,0,83,0,140,0,34,0,200,0,37,0,254,0,143,0,105,0,108,0,175,0,241,0,0,0,108,0,83,0,73,0,9,0,191,0,72,0,136,0,79,0,229,0,236,0,38,0,23,0,131,0,219,0,61,0,218,0,189,0,151,0,9,0,187,0,56,0,91,0,225,0,161,0,144,0,52,0,83,0,80,0,103,0,97,0,0,0,169,0,0,0,5,0,71,0,57,0,73,0,203,0,102,0,0,0,237,0,0,0,191,0,116,0,161,0,196,0,178,0,28,0,216,0,4,0,16,0,166,0,223,0,41,0,129,0,164,0,239,0,199,0,57,0,0,0,73,0,215,0,0,0,76,0,130,0,84,0,245,0,43,0,179,0,183,0,0,0,197,0,25,0,156,0,132,0,180,0,14,0,0,0,215,0,84,0,126,0,223,0,147,0,9,0,181,0,56,0,49,0,176,0,53,0,0,0,0,0,0,0,0,0,211,0,0,0,144,0,98,0,182,0,173,0,0,0,172,0,56,0,209,0,0,0,236,0,62,0,184,0,35,0,251,0,0,0,0,0,25,0,218,0,242,0,124,0,101,0,0,0,109,0,132,0,0,0,180,0,103,0,134,0,63,0,72,0,14,0,234,0,196,0,92,0,180,0,123,0,118,0,79,0,213,0,18,0,70,0,183,0,239,0,193,0,0,0,0,0,0,0,241,0,134,0,156,0,17,0,221,0,0,0,0,0,52,0,69,0,136,0,0,0,156,0,0,0,111,0,72,0,202,0,36,0,0,0,194,0,197,0,130,0,235,0,220,0,74,0,195,0,254,0,71,0,138,0,0,0,14,0,141,0,8,0,46,0,122,0,153,0,202,0,0,0,3,0,115,0,77,0,0,0,50,0,192,0,230,0,105,0,0,0,43,0,197,0,158,0,187,0,119,0,53,0,66,0,50,0,176,0,0,0,0,0,135,0,243,0,220,0,107,0,128,0,130,0,221,0,164,0,159,0,0,0,84,0,230,0,0,0,150,0,168,0,0,0,192,0,56,0,202,0,0,0,89,0,51,0,65,0,85,0,109,0,0,0,0,0,255,0,36,0,0,0,190,0,93,0,139,0,0,0,174,0,0,0,190,0,28,0,255,0,134,0,0,0,254,0,56,0,0,0,88,0,0,0,192,0,5,0,175,0,8,0,190,0,219,0,58,0,41,0,83,0,36,0,17,0,185,0,0,0,27,0,171,0,237,0,0,0,15,0,0,0,0,0,0,0,211,0,251,0,154,0,189,0,122,0,0,0,217,0,249,0,0,0,200,0,74,0,27,0,252,0,107,0,0,0,242,0,196,0,187,0,15,0,80,0,237,0,140,0,189,0,79,0,0,0,0,0,208,0,43,0,204,0,138,0,184,0,38,0,140,0,236,0,96,0,1,0,0,0,0,0,0,0,0,0,146,0,136,0,38,0,246,0,68,0,0,0,6,0,219,0,32,0,87,0,138,0,245,0,17,0,197,0,53,0,242,0,138,0,239,0,189,0,2,0,250,0,74,0,59,0,80,0,207,0,58,0,224,0,209,0,125,0,0,0,0,0,188,0,60,0,5,0,4,0,34,0,139,0,195,0,224,0,218,0,181,0,0,0,203,0,71,0,170,0,137,0,0,0,28,0,13,0,0,0,88,0,136,0,211,0,16,0,0,0,18,0,31,0,0,0,115,0,233,0,0,0,21,0,74,0,96,0,170,0,0,0,252,0,156,0,0,0,9,0,204,0,13,0,0,0,33,0,178,0,159,0,0,0,233,0,153,0,154,0,91,0,226,0,236,0,235,0,66,0,0,0,0,0,163,0,56,0,0,0,175,0,51,0,0,0,0,0,117,0,177,0,0,0,138,0,0,0,0,0,134,0,225,0,0,0,201,0,0,0,253,0,23,0,178,0,0,0,91,0,0,0,89,0,105,0,189,0,96,0,0,0,167,0,218,0,167,0,150,0,25,0,191,0,56,0,0,0,176,0,134,0,2,0,64,0,183,0,89,0,0,0,106,0,72,0,0,0,0,0,238,0,0,0,42,0,101,0,0,0,24,0,253,0,13,0,46,0,168,0,184,0,87,0,0,0,211,0,83,0,120,0,232,0,122,0,209,0,199,0,244,0,37,0,0,0,102,0,166,0,196,0,0,0,0,0,118,0,2,0,90,0,87,0,0,0,149,0,240,0,29,0,168,0,214,0,217,0,41,0,185,0,67,0,102,0,192,0,93,0,0,0,155,0,142,0,82,0,65,0,204,0,0,0,240,0,191,0,210,0,170,0,236,0,37,0,148,0,0,0,46,0,141,0,229,0,226,0,66,0,0,0,114,0,86,0,53,0,116,0,98,0,209,0,224,0,6,0,233,0,7,0,0,0,209,0,197,0,26,0,80,0,132,0,0,0,0,0,231,0,0,0);
signal scenario_full  : scenario_type := (132,31,186,31,197,31,19,31,19,30,98,31,41,31,140,31,178,31,178,30,67,31,83,31,140,31,34,31,200,31,37,31,254,31,143,31,105,31,108,31,175,31,241,31,241,30,108,31,83,31,73,31,9,31,191,31,72,31,136,31,79,31,229,31,236,31,38,31,23,31,131,31,219,31,61,31,218,31,189,31,151,31,9,31,187,31,56,31,91,31,225,31,161,31,144,31,52,31,83,31,80,31,103,31,97,31,97,30,169,31,169,30,5,31,71,31,57,31,73,31,203,31,102,31,102,30,237,31,237,30,191,31,116,31,161,31,196,31,178,31,28,31,216,31,4,31,16,31,166,31,223,31,41,31,129,31,164,31,239,31,199,31,57,31,57,30,73,31,215,31,215,30,76,31,130,31,84,31,245,31,43,31,179,31,183,31,183,30,197,31,25,31,156,31,132,31,180,31,14,31,14,30,215,31,84,31,126,31,223,31,147,31,9,31,181,31,56,31,49,31,176,31,53,31,53,30,53,29,53,28,53,27,211,31,211,30,144,31,98,31,182,31,173,31,173,30,172,31,56,31,209,31,209,30,236,31,62,31,184,31,35,31,251,31,251,30,251,29,25,31,218,31,242,31,124,31,101,31,101,30,109,31,132,31,132,30,180,31,103,31,134,31,63,31,72,31,14,31,234,31,196,31,92,31,180,31,123,31,118,31,79,31,213,31,18,31,70,31,183,31,239,31,193,31,193,30,193,29,193,28,241,31,134,31,156,31,17,31,221,31,221,30,221,29,52,31,69,31,136,31,136,30,156,31,156,30,111,31,72,31,202,31,36,31,36,30,194,31,197,31,130,31,235,31,220,31,74,31,195,31,254,31,71,31,138,31,138,30,14,31,141,31,8,31,46,31,122,31,153,31,202,31,202,30,3,31,115,31,77,31,77,30,50,31,192,31,230,31,105,31,105,30,43,31,197,31,158,31,187,31,119,31,53,31,66,31,50,31,176,31,176,30,176,29,135,31,243,31,220,31,107,31,128,31,130,31,221,31,164,31,159,31,159,30,84,31,230,31,230,30,150,31,168,31,168,30,192,31,56,31,202,31,202,30,89,31,51,31,65,31,85,31,109,31,109,30,109,29,255,31,36,31,36,30,190,31,93,31,139,31,139,30,174,31,174,30,190,31,28,31,255,31,134,31,134,30,254,31,56,31,56,30,88,31,88,30,192,31,5,31,175,31,8,31,190,31,219,31,58,31,41,31,83,31,36,31,17,31,185,31,185,30,27,31,171,31,237,31,237,30,15,31,15,30,15,29,15,28,211,31,251,31,154,31,189,31,122,31,122,30,217,31,249,31,249,30,200,31,74,31,27,31,252,31,107,31,107,30,242,31,196,31,187,31,15,31,80,31,237,31,140,31,189,31,79,31,79,30,79,29,208,31,43,31,204,31,138,31,184,31,38,31,140,31,236,31,96,31,1,31,1,30,1,29,1,28,1,27,146,31,136,31,38,31,246,31,68,31,68,30,6,31,219,31,32,31,87,31,138,31,245,31,17,31,197,31,53,31,242,31,138,31,239,31,189,31,2,31,250,31,74,31,59,31,80,31,207,31,58,31,224,31,209,31,125,31,125,30,125,29,188,31,60,31,5,31,4,31,34,31,139,31,195,31,224,31,218,31,181,31,181,30,203,31,71,31,170,31,137,31,137,30,28,31,13,31,13,30,88,31,136,31,211,31,16,31,16,30,18,31,31,31,31,30,115,31,233,31,233,30,21,31,74,31,96,31,170,31,170,30,252,31,156,31,156,30,9,31,204,31,13,31,13,30,33,31,178,31,159,31,159,30,233,31,153,31,154,31,91,31,226,31,236,31,235,31,66,31,66,30,66,29,163,31,56,31,56,30,175,31,51,31,51,30,51,29,117,31,177,31,177,30,138,31,138,30,138,29,134,31,225,31,225,30,201,31,201,30,253,31,23,31,178,31,178,30,91,31,91,30,89,31,105,31,189,31,96,31,96,30,167,31,218,31,167,31,150,31,25,31,191,31,56,31,56,30,176,31,134,31,2,31,64,31,183,31,89,31,89,30,106,31,72,31,72,30,72,29,238,31,238,30,42,31,101,31,101,30,24,31,253,31,13,31,46,31,168,31,184,31,87,31,87,30,211,31,83,31,120,31,232,31,122,31,209,31,199,31,244,31,37,31,37,30,102,31,166,31,196,31,196,30,196,29,118,31,2,31,90,31,87,31,87,30,149,31,240,31,29,31,168,31,214,31,217,31,41,31,185,31,67,31,102,31,192,31,93,31,93,30,155,31,142,31,82,31,65,31,204,31,204,30,240,31,191,31,210,31,170,31,236,31,37,31,148,31,148,30,46,31,141,31,229,31,226,31,66,31,66,30,114,31,86,31,53,31,116,31,98,31,209,31,224,31,6,31,233,31,7,31,7,30,209,31,197,31,26,31,80,31,132,31,132,30,132,29,231,31,231,30);

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
